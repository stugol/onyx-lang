require "./base_type_visitor"
require "./type_guess_visitor"

module Crystal
  class Program
    def visit_type_declarations(node)
      # First check type declarations
      visitor = TypeDeclarationVisitor.new(self)
      node.accept visitor

      # Use the last type found for global variables to declare them
      visitor.globals.each do |name, type|
        declare_meta_type_var(self.global_vars, self, name, type)
      end

      # Use the last type found for class variables to declare them
      visitor.class_vars.each do |owner, vars|
        vars.each do |name, type|
          declare_meta_type_var(owner.class_vars, owner, name, type)
        end
      end

      # Now use several syntactic rules to infer the types of
      # variables that don't have an explicit type set
      visitor = TypeGuessVisitor.new(self)
      node.accept visitor

      # Process global variables
      visitor.globals.each do |name, info|
        declare_meta_type_var(self.global_vars, self, name, info)
      end

      # Process class variables
      visitor.class_vars.each do |owner, vars|
        vars.each do |name, info|
          declare_meta_type_var(owner.class_vars, owner, name, info)
        end
      end

      node
    end

    private def declare_meta_type_var(vars, owner, name, type : Type)
      var = MetaTypeVar.new(name)
      var.owner = owner
      var.type = type
      var.bind_to(var)
      var.freeze_type = type
      vars[name] = var
    end

    private def declare_meta_type_var(vars, owner, name, info : TypeGuessVisitor::TypeInfo)
      type = info.type
      type = Type.merge!(type, self.nil) unless info.outside_def
      declare_meta_type_var(vars, owner, name, type)
    end
  end

  # In this pass we check type declarations like:
  #
  #     @x : Int32
  #     @@x : Int32
  #     $x : Int32
  #
  # In this way we declare their type before the "main" code.
  #
  # This allows to put "main" code before these declarations,
  # so order matters less in the end.
  #
  # In the future these will be mandatory and after this pass
  # we'll have a complete definition of the type hierarchy and
  # their instance/class variables types.
  class TypeDeclarationVisitor < BaseTypeVisitor
    getter globals
    getter class_vars

    def initialize(mod)
      super(mod)

      # The type of global variables. The last one wins.
      @globals = {} of String => Type

      # The type of class variables. The last one wins.
      # This is type => variables.
      @class_vars = {} of ClassVarContainer => Hash(String, Type)
    end

    def visit(node : ClassDef)
      check_outside_block_or_exp node, "declare class"

      pushing_type(node.resolved_type) do
        node.runtime_initializers.try &.each &.accept self
        node.body.accept self
      end

      false
    end

    def visit(node : ModuleDef)
      check_outside_block_or_exp node, "declare module"

      pushing_type(node.resolved_type) do
        node.body.accept self
      end

      false
    end

    def visit(node : EnumDef)
      check_outside_block_or_exp node, "declare enum"

      pushing_type(node.resolved_type) do
        node.members.each &.accept self
      end

      false
    end

    def visit(node : Alias)
      check_outside_block_or_exp node, "declare alias"

      false
    end

    def visit(node : Include)
      check_outside_block_or_exp node, "include"

      node.runtime_initializers.try &.each &.accept self

      false
    end

    def visit(node : Extend)
      check_outside_block_or_exp node, "extend"

      node.runtime_initializers.try &.each &.accept self

      false
    end

    def visit(node : LibDef)
      check_outside_block_or_exp node, "declare lib"

      false
    end

    def visit(node : FunDef)
      false
    end

    def visit(node : TypeDeclaration)
      _dbg "TypeDeclarationVisitor.visit(#{node} TypeDeclaration) ->"

      case var = node.var
      when Var
        node.raise "declaring the type of a local variable is not yet supported"
      when InstanceVar
        declare_instance_var(node, var)
      when ClassVar
        owner = class_var_owner(node)
        var_type = lookup_type(node.declared_type).virtual_type
        var_type = check_declare_var_type(node, var_type)
        owner_vars = @class_vars[owner] ||= {} of String => Type
        owner_vars[var.name] = var_type
      when Global
        var_type = lookup_type(node.declared_type).virtual_type
        var_type = check_declare_var_type(node, var_type)
        @globals[var.name] = var_type
      end

      false
    end

    def declare_instance_var(node, var)
      type = current_type
      case type
      when NonGenericClassType
        var_type = lookup_type(node.declared_type)
        var_type = check_declare_var_type(node, var_type)
        type.declare_instance_var(var.name, var_type.virtual_type)
        return
      when GenericClassType
        type.declare_instance_var(var.name, node.declared_type)
        return
      when GenericModuleType
        type.declare_instance_var(var.name, node.declared_type)
        return
      when GenericClassInstanceType
        # OK
        return
      when Program, FileModule
        # Error, continue
      when NonGenericModuleType
        var_type = lookup_type(node.declared_type)
        var_type = check_declare_var_type(node, var_type)
        type.declare_instance_var(var.name, var_type.virtual_type)
        return
      end

      node.raise "can only declare instance variables of a non-generic class, not a #{type.type_desc} (#{type})"
    end

    def visit(node : Def)
      check_outside_block_or_exp node, "declare def"

      node.runtime_initializers.try &.each &.accept self

      false
    end

    def visit(node : Macro)
      check_outside_block_or_exp node, "declare macro"

      false
    end

    def visit(node : Call)
      if node.global
        node.scope = @mod
      else
        node.scope = current_type.metaclass
      end

      if expand_macro(node, raise_on_missing_const: false)
        false
      else
        true
      end
    end

    def lookup_type(node)
      TypeLookup.lookup(current_type, node, allow_typeof: false)
    end

    def visit(node : UninitializedVar)
      false
    end

    def visit(node : Assign)
      false
    end

    def visit(node : FunLiteral)
      false
    end

    def visit(node : IsA)
      false
    end

    def visit(node : Cast)
      false
    end

    def visit(node : InstanceSizeOf)
      false
    end

    def visit(node : SizeOf)
      false
    end

    def visit(node : TypeOf)
      false
    end

    def visit(node : PointerOf)
      false
    end

    def visit(node : ArrayLiteral)
      false
    end

    def visit(node : HashLiteral)
      false
    end

    def visit(node : Path)
      false
    end

    def visit(node : Generic)
      false
    end

    def visit(node : Fun)
      false
    end

    def visit(node : Union)
      false
    end

    def visit(node : Metaclass)
      false
    end

    def visit(node : Self)
      false
    end

    def visit(node : TypeOf)
      false
    end

    def inside_block?
      false
    end
  end
end
