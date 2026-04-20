# 🚀 PocketShelf — SEO Mastery & Marketing Kit

Use these assets to launch PocketShelf and dominate the "Free Dropover Alternative" search category.

---

## 🏷️ GitHub Repository Settings (TOP PRIORITY)

Go to your GitHub repo's **About** settings and copy-paste these:

### Description
> A magical, floating shelf for macOS. The best free & open-source alternative to Dropover and Yoink. 100% on-device AI renaming, notch interaction, and multi-shelf management.

### Topics (Add ALL of these)
`macos`, `productivity`, `swiftui`, `drag-and-drop`, `utility`, `open-source`, `dropover-alternative`, `yoink-alternative`, `file-management`, `apple-silicon`, `on-device-ai`, `workflow-automation`, `notch`, `finder-alternative`, `desktop-enhancement`, `staging-area`, `free-software`, `privacy-first`.

---

## 📢 Launch Templates

### Reddit (r/macapps) - "The Honest Founder" Pitch
**Title:** I was tired of paid alternatives for macOS file stashing, so I built PocketShelf (100% Free & Open Source)

**Body:**
> Hey r/macapps!
>
> Like many of you, I love the "shelf" concept for dragging files, but I wasn't a fan of the subscriptions or paid tiers in existing apps. So I spent the last few weeks building **PocketShelf**.
>
> **What makes it different?**
> 1. **100% Free & Open Source**: No catches, no "pro" versions for basic features.
> 2. **On-Device AI**: It uses Apple's Neural Engine to "read" your files and suggest smart names (OCR/NLP) — all locally for privacy.
> 3. **Notch Interaction**: A cool "glow" effect when you drag items near your camera notch.
> 4. **Shake to Open**: The same gesture you love, now in a free app.
>
> I'd love your feedback!
> **GitHub:** https://github.com/akayyt786/PocketShelf

---

## 📦 Homebrew Cask Submission
To get into the Mac power-user workflow, submit this Cask to `homebrew-cask`.

```ruby
cask "pocketshelf" do
  version "1.0.0"
  sha256 "REPLACE_WITH_SHA256_OF_APP_DMG"

  url "https://github.com/akayyt786/PocketShelf/releases/download/v#{version}/PocketShelf.dmg"
  name "PocketShelf"
  desc "Magical floating shelf for macOS"
  homepage "https://github.com/akayyt786/PocketShelf"

  app "PocketShelf.app"

  zap trash: [
    "~/Library/Application Support/PocketShelf",
    "~/Library/Preferences/com.pocketshelf.macos.plist",
  ]
end
```

---

## 📈 Long-Tail SEO Keywords
Include these in any social posts or blog articles to capture high-intent traffic:
- "Save files to notch Mac"
- "How to move files between spaces Mac easily"
- "MacOS shelf app that doesn't track you"
- "Yoink vs Dropover vs PocketShelf"
