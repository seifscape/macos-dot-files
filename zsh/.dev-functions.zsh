# ====================================
# Dev Tool Functions
# ====================================

# --------- updates ---------

# Update all dev tools (brew + mise)
dev-refresh() {
  echo "🔁 Updating tools..."
  brew update && brew upgrade
  mise upgrade --yes && mise reshim
  echo "✅ Dev tools refreshed."
}
