# Architecture Overview

```txt
src
├── assets       # Static images & files
├── background      # Manages the background script processes
│   ├── analysis
│   │   ├── analysis-listeners.js
│   │   └── analysis.js
│   ├── control.js
│   ├── cookiesIAB.js
│   ├── storage.js
│   └── storageCookies.js
├── common       # Manages header sending and rules
│   ├── csvGenerator.js
│   ├── editDomainlist.js
│   └── editRules.js
├── content-scripts     # Runs processes on site on adds DOM signal
│   ├── injection
│   │   ├── gpc-dom.js
│   │   └── gpc-remove.js
│   ├── registration
│   │   ├── gpc-dom.js
│   │   └── gpc-remove.js
│   └── contentScript.js
├── data       # Stores constant data (DNS signals, settings, etc.)
│   ├── cookie_list.js
│   ├── defaultSettings.js
│   ├── headers.js
│   ├── modes.js
│   ├── privacyFlags.js
│   └── regex.js
├── manifests      # Stores manifests
│   ├── chrome
│   │   ├── manifest-dev.json
│   │   └── manifest-dist.json
│   ├── firefox
│   │   ├── manifest-dev.json
│   │   └── manifest-dist.json
└──rules       # Manages universal rules
    ├── gpc_exceptions_rules.json
    └── universal_gpc_rules.json
```

The following source folders have detailed descriptions further in the document.

[background](#background)\
[common](#common)\
[content-scripts](#content-scripts)\
[data](#data)\
[manifests](#manifests)\
[rules](#rules)


## background

1. `analysis`
2. `control.js`
3. `cookiesIAB.js`
4. `storage.js`
5. `storageCookies.js`

The background folder has an `analysis` folder that builds analysis mode.

### `src/background/analysis`

1. `analysis-listeners.js`
2. `analysis.js`

#### `analysis/analysis-listeners.js`

Initializes the listeners for analysis mode using `webRequest` and `webNavigation` (links found below). This file only needs to deal with Firefox listeners as analysis mode is not available on Chrome.

#### `analysis/analysis.js`

Contains all the logic and processes for running analysis mode. `FetchUSPCookies();` is used to identify and save US Privacy cookies and `fetchUSPAPIData();` uses the USPAPI query to check the US Privacy string. `runAnalysis();` collects the US Privacy values and sends the GPC signal. `haltAnalysis();` then rechecks the US Privacy values and removes the GPC signal, then allowing the US Privacy Values from before and after to be compared. `logData();` then records the found data to local storage.

### `background/control.js`

Uses `analysis.js` and `protection.js` to switch between modes.

### `background/cookiesIAB.js`

Is responsible for setting valid IAB cookies.

### `background/storage.js`

Handles storage uploads and downloads.

### `background/storageCookies.js`

Handles cookie creation and deletion.

## common

1. `csvGenerator.js`
2. `editDomainlist.js`
3. `editRules.js`

This folder holds common internal API's to be used throughout the extension.

### `common/csvGenerator.js`

Creates a CSV file of the users local collected data.

### `common/editDomainlist.js`

Is an internal API to be used for editing a users domain list.

### `common/editRules.js`

Is an internal API to be used for editing rules that allow us to send the GPC header.

## content-scripts

1. `injection`
2. `registration`
3. `contentScript.js`

This folder contains our main content script and methods for injecting the GPC signal into the DOM.

### `src/content-scripts/injection`

1. `gpc-dom.js`
2. `gpc-remove.js`

`gpc-dom.js` the GPC DOM signal and `gpc-remove.js` removes it.

### `src/content-scripts/registration`

1. `gpc-dom.js`
2. `gpc-remove.js`

These files inject `injection/gpc-dom.js` and `injection/gpc-remove.js` into the page using a static script. (Based on [this stack overflow thread](https://stackoverflow.com/questions/9515704/use-a-content-script-to-access-the-page-context-variables-and-functions))

### `content-scripts/contentScript.js`

This runs on every page and sends information to signal background processes.

## data

1. `cookie_list.js`
2. `defaultSettings.js`
3. `headers.js`
4. `modes.js`
5. `privacyFlags.js`
6. `regex.js`

This folder contains static data.

### `data/cookie_list.js`

Contains opt out cookies that are set on install.

### `data/defaultSettings.js`

Contains the default OptMeowt settings.

### `data/headers.js`

Contains the default headers to be attached to online requests.

### `data/modes.js`

Contains the modes for OptMeowt.

### `data/privacyFlags.js`

Contains all privacy flags for analysis

### `data/regex.js`

Contains regular expressions for finding "do not sell" links and relevant cookies

## manifests

1. `chrome`
2. `firefox`

Contains the extension manifests

### `manifests/chrome`

1. `manifest-dev.json`
2. `manifest-dist.json`

Contains the development and distribution manifests for Chrome

### `manifests/firefox`

1. `manifest-dev.json`
2. `manifest-dist.json`

Contains the development and distribution manifests for Firefox

## rules

1. `gpc_exception_rules.json`
2. `universal_gpc_rules.json`

Contains rule framework for sending GPC headers to sites.

**Links to APIs:**

Chrome: [webRequest](https://developer.chrome.com/docs/extensions/reference/webRequest/) and [webNavigation](https://developer.chrome.com/docs/extensions/reference/webNavigation/)

Firefox: [webRequest](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API/webRequest) and [webNavigation](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/API/webNavigation)
