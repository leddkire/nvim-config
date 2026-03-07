return require("telescope").register_extension {
  setup = function(ext_config, config)
    -- access extension config and user config
  end,
  exports = {
    local_declarations = require("custom_telescope_pickers.local_declarations")
  },
}
