# Sbricktify for TrimUI Brick Pro

Sbricktify is the branded SDL2 user interface for the existing verified
Spotify Connect receiver.

The app folder intentionally remains Apps/SpotifastBrickSpeaker in this
release. That preserves its existing data/, device-bound receiver vault,
saved Web API session, and runtime paths. The TrimUI Apps menu label is
**Sbricktify**.

## Spotify Connect identity

The receiver continues to appear in Spotify Connect as **TrimUI Brick Speaker**.
Its Connect device ID is derived from that name; renaming it would create a
different device identity and can invalidate the previously paired receiver.
This release preserves the receiver, librespot, ALSA, device identity, and
launcher lifecycle. It adds only a short-lived local QR page for Web API
sign-in.

## Use

1. With TrimUI powered off, use an SD-card reader to copy the contained
   Apps/SpotifastBrickSpeaker folder to the SD card's Apps directory,
   replacing only the application files while preserving data/ if it exists.
2. Safely eject the card, return it to the Brick, and open **Sbricktify** from
   Apps.
3. Keep Wi-Fi connected. In Spotify Connect, select **TrimUI Brick Speaker**;
   this is the stable receiver identity used by Sbricktify.
4. Browse a playlist, choose a track with analog + A, then use X / L / R for
   play-pause / previous / next. B returns or exits according to the UI.

No credentials, vault, access token, refresh token, or relay secret are
included in this package.

## Logs after a device test

- Apps/SpotifastBrickSpeaker/logs/launcher.log
- Apps/SpotifastBrickSpeaker/logs/receiver.log
- Apps/SpotifastBrickSpeaker/logs/spotifast-ui.log
- Apps/SpotifastBrickSpeaker/run/receiver.status

The log and data filenames intentionally retain their stable internal names.

## Rollback

To remove only the local QR change, restore `Sbricktify-01.1.zip`. To return
to the previously verified playback package, restore
`SpotifastBrickSpeakerLab-01.5.zip`. Do not delete
`data/receiver/credentials.vault` unless you want to pair the receiver again.

## QR sign-in without a relay or PC

The packaged launcher enables a temporary HTTP pairing page on the Brick's
current Wi-Fi IPv4 address. It does not use a public relay, VPS, cloud service,
PC relay, or browser on the Brick. Keep the phone and Brick on the same Wi-Fi
network. Guest Wi-Fi that blocks device-to-device traffic will not work.

1. Open **Sbricktify** and wait for the QR code, pairing address, and six-digit
   PIN. The session expires after five minutes.
2. Scan the QR code with the phone. If scanning is unavailable, enter the
   address shown on the Brick in the phone browser.
3. Enter the PIN on the Sbricktify page and select **Sign in with Spotify**. The next page opens Spotify automatically. If Chrome leaves that page visible, select **Continue to Spotify** there; do not reload the pairing page.
4. After Spotify approval, the phone is redirected to
   `http://127.0.0.1:8989/login`. This is a registered Spotify loopback
   redirect for the existing Web API client, not the Brick's LAN address. It
   can display a browser error because `127.0.0.1` refers to the phone.
5. Copy the complete URL from the phone browser's address bar, return to the
   Sbricktify pairing page, enter the PIN again, paste the URL, and select
   **Confirm callback**.

The Brick validates the callback's exact loopback origin, path and OAuth
state, then exchanges the one-time code with its in-memory PKCE verifier. The
phone never receives the verifier, access token, refresh token, credential
vault, or Spotify password. HTTP on a LAN is not encrypted, so use a trusted
Wi-Fi network and finish or cancel the short session promptly.

Each pairing form carries a one-time anti-forgery value, verified together with the exact Brick host and request type. Browser `Origin` and Fetch Metadata are diagnostics because Chrome can serialize a QR hand-off inconsistently; requests without the nonce, with the wrong host, duplicate `Origin`, or an unsupported body remain rejected.

`config/qr-relay.json` remains empty and is ignored while local QR is enabled.
No Client Secret, relay URL, or external configuration is needed for this
package. If the mobile browser does not let you copy the loopback callback
address, this flow cannot complete in that browser. Generate a new QR code and
use another browser rather than treating the failed redirect page as success.

## QR scan quality

Build 01.3 renders the pairing QR as opaque `#000000` and `#FFFFFF` pixels at an integer module size, using nearest-neighbor sampling. It does not use the app theme's text colour.
