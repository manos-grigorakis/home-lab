# Windows Hardening PowerShell Script

## Overview

This PowerShell script applies security hardening settings (registry, audit policies, account policies) based on CIS Benchmark recommendations, as referenced by Wazuh (CIS Microsoft Windows 11 Enterprise Benchmark v3.0.0)

## Compatibility

**Tested on:**

- Windows 11

> Some audit policy commands rely on English subcategory names. On non-English systems these commands may fail.

## Instructions

1. Open PowerShell as Administrator

2. Enable Script Execution (only for this session)

   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ```

3. Execute PowerShell Script
   ```powershell
   .\baseline.ps1
   ```
