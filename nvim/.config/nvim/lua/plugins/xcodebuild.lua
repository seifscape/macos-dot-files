-- xcodebuild.lua
return {
    "wojciech-kulik/xcodebuild.nvim",
    ft = { "swift", "objc", "objective-c" }, -- lazy-load for iOS/macOS dev files
    config = function()
      require("xcodebuild").setup({})
    end,
    cmd = {
      "XcodeBuild", "XcodeRun", "XcodeTest", "XcodeSelectScheme",
      "XcodeDevices", "XcodeOpenLogs"
    },
  }
