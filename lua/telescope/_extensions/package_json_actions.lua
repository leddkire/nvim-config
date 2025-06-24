return require("telescope").register_extension {
  exports = {
    package_json_actions = require("custom_telescope_pickers.package_json_actions")
  },
}
