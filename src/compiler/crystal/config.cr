include "../onyx/version_number.cr"

module Crystal
  module Config
    PATH      = {{ env("CRYSTAL_CONFIG_PATH") || "" }}
    VERSION   = ONYX_VERSION
    # VERSION = {{ env("CRYSTAL_CONFIG_VERSION") || `(git describe --tags --long 2>/dev/null)`.stringify.chomp }}
    # CACHE_DIR = ENV["CRYSTAL_CACHE_DIR"]? || ".crystal"
    CACHE_DIR = ENV["CRYSTAL_CACHE_DIR"]? || ".onyx-cache"

    @@cache_dir : String?

    def self.cache_dir
      @@cache_dir ||= File.expand_path(CACHE_DIR)
    end
  end
end
