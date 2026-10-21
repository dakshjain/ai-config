---
name: prefer-local-files
description: User wants dashboards, reports and HTML pages saved as local files, not published to a hosted service
metadata:
  type: feedback
---

Save dashboards, reports and HTML pages under ~/Documents and open them with `open`. Do not publish them.

**Why:** A hosted page I relied on disappeared; local files are durable and private by default.

**How to apply:** Write outputs to a persistent folder under ~/Documents, not the session scratchpad, which is temporary.
