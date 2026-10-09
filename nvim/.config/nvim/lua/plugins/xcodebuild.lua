-- xcodebuild.lua
return {
    "wojciech-kulik/xcodebuild.nvim",
    -- macOS only: it drives Xcode. cond (not deleting the file on Linux) keeps the
    -- plugin in lazy-lock.json, so the shared lock file doesn't churn there.
    cond = vim.fn.has("mac") == 1,
    ft ={ "swift", "objc", "objective-c" }, -- lazy-load for iOS/macOS dev files
    config = function()
      require("xcodebuild").setup({})
    end,
    cmd = {
      "XcodeBuild", "XcodeRun", "XcodeTest", "XcodeSelectScheme",
      "XcodeDevices", "XcodeOpenLogs"
    },
  }
