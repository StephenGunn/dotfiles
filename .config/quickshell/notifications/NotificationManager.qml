import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import "../"

QtObject {
    id: manager

    property var screen
    property int maxNotifications: 5
    property list<NotificationPopup> popups: []

    property NotificationServer server: NotificationServer {
        // Advertise capabilities
        bodySupported: true
        bodyMarkupSupported: true
        actionsSupported: true
        imageSupported: true
        persistenceSupported: false
        keepOnReload: true

        onNotification: notification => {
            notification.tracked = true
            manager.showNotification(notification)
        }
    }

    property Component popupComponent: Component {
        NotificationPopup {}
    }

    function showNotification(notification) {
        // Remove oldest if at max
        while (popups.length >= maxNotifications) {
            const oldest = popups[popups.length - 1]
            if (oldest && !oldest.exiting) {
                oldest.startExit()
            }
            popups = popups.slice(0, -1)
        }

        // Shift existing popups down
        for (let i = 0; i < popups.length; i++) {
            if (popups[i]) {
                popups[i].index = i + 1
            }
        }

        // Create new popup at top
        const popup = popupComponent.createObject(null, {
            notification: notification,
            screen: manager.screen,
            index: 0
        })

        if (popup) {
            popup.dismissed.connect(() => removePopup(popup))
            popup.exitFinished.connect(() => destroyPopup(popup))
            popups = [popup].concat(popups)
        }
    }

    function removePopup(popup) {
        const idx = popups.indexOf(popup)
        if (idx !== -1) {
            popups = popups.filter((p, i) => i !== idx)
            // Reindex remaining popups
            for (let i = 0; i < popups.length; i++) {
                if (popups[i]) popups[i].index = i
            }
        }
    }

    function destroyPopup(popup) {
        const idx = popups.indexOf(popup)
        if (idx !== -1) {
            popups = popups.filter((p, i) => i !== idx)
        }
        if (popup) {
            popup.destroy()
        }
        // Reindex remaining popups
        for (let i = 0; i < popups.length; i++) {
            if (popups[i]) popups[i].index = i
        }
    }

    function dismissAll() {
        for (const popup of popups) {
            if (popup && !popup.exiting) {
                popup.startExit()
            }
        }
    }
}
