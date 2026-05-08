return {
  "wojciech-kulik/xcodebuild.nvim",
  ft = { "swift", "objc", "objective-c" },
  config = function()
    require("xcodebuild").setup({})
  end,
  cmd = {
    "XcodeBuild", "XcodeRun", "XcodeTest", "XcodeSelectScheme",
    "XcodeDevices", "XcodeOpenLogs"
  },
}
