# BaileyPoint.SPMT.Tools

🛠 A PowerShell module for identifying and removing **unsupported SharePoint lists** before migrating from SharePoint Server to SharePoint Online using the **SharePoint Migration Tool (SPMT)**.

---

## ✨ Features

- Detects legacy, hidden, or deprecated list types (Quick Deploy, Notifications, Device Channels, etc.)
- Removes problematic lists cleanly, with optional force prompt
- Supports recursion across site collections and subwebs
- Lint-safe, modular, and extensible for enterprise cleanup

---

## 📦 Installation

This module is not yet published to the PowerShell Gallery.

To test or use locally:

```powershell
git clone https://github.com/SolusCado/SPMT-Tools.git
cd SPMT-Tools
Import-Module ./BaileyPoint.SPMT.Tools.psd1 -Force
```

---

## 🚀 Usage

### 🫼 Clean up unsupported lists (auto + interactive)

```powershell
Invoke-SPMTListCleanup -SiteUrl "http://sharepoint2013/sites/demo"
```

### 🔍 Just scan and review

```powershell
Get-SPMTUnsupportedLists -SiteUrl "http://sharepoint2013/sites/hr" |
    Format-Table Title, Hidden, ItemCount
```

### 🭹 Manual delete with optional `-Force`

```powershell
$list = Get-SPWeb "http://site" | % { $_.Lists["Quick Deploy Items"] }
Remove-SPMTUnsupportedList -List $list
```

---

## 🔧 Exported Commands

| Command                      | Description                                |
|-----------------------------|--------------------------------------------|
| `Invoke-SPMTListCleanup`     | Full scan and optional removal flow        |
| `Get-SPMTUnsupportedLists`   | Find known-bad lists without removing them |
| `Remove-SPMTUnsupportedList` | Delete a specific list with confirmation   |

---

## 📁 Folder Structure

Follows the [PowerShell module best practices](https://learn.microsoft.com/en-us/powershell/scripting/developer/module/authoring-script-modules).

```
BaileyPoint.SPMT.Tools/
├── Public/
├── Private/
├── BaileyPoint.SPMT.Tools.psd1
├── BaileyPoint.SPMT.Tools.psm1
└── README.md
```

---

## 🤛 About

**Author:** Michael Bailey  
**Company:** BaileyPoint  
**License:** MIT  
**Repo:** [github.com/SolusCado/SPMT-Tools](https://github.com/SolusCado/SPMT-Tools)

---