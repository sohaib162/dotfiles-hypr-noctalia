import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../../Helpers/TextFormatter.js" as TextFormatter
import qs.Commons
import qs.Services.Keyboard
import qs.Widgets

Item {
  id: previewPanel

  property var currentItem: null
  property string fullContent: ""
  property string imageDataUrl: ""
  property bool loadingFullContent: false
  property bool isImageContent: false

  implicitHeight: contentColumn.implicitHeight + Style.marginL * 2

  Connections {
    target: previewPanel
    function onCurrentItemChanged() {
      fullContent = "";
      imageDataUrl = "";
      loadingFullContent = false;
      isImageContent = currentItem && currentItem.isImage;

      if (currentItem && currentItem.clipboardId) {
        if (isImageContent) {
          imageDataUrl = ClipboardService.getImageData(currentItem.clipboardId) || "";
          loadingFullContent = !imageDataUrl;

          if (!imageDataUrl && currentItem.mime) {
            ClipboardService.decodeToDataUrl(currentItem.clipboardId, currentItem.mime, null);
          }
        } else {
          loadingFullContent = true;
          ClipboardService.decode(currentItem.clipboardId, function (content) {
            fullContent = TextFormatter.wrapTextForDisplay(content);
            loadingFullContent = false;
          });
        }
      }
    }
  }

  readonly property int _rev: ClipboardService.revision

  Timer {
    id: imageUpdateTimer
    interval: 200
    running: currentItem && currentItem.isImage && imageDataUrl === ""
    repeat: currentItem && currentItem.isImage && imageDataUrl === ""

    onTriggered: {
      if (currentItem && currentItem.clipboardId) {
        const newData = ClipboardService.getImageData(currentItem.clipboardId) || "";
        if (newData !== imageDataUrl) {
          imageDataUrl = newData;
          if (newData) loadingFullContent = false;
        }
      }
    }
  }

  // Outer container
  Rectangle {
    anchors.fill: parent
    color: Color.mSurface || "#111418"
    border.color: Color.mOutlineVariant || "#2a2f36"
    border.width: 1
    radius: Style.radiusM

    ColumnLayout {
      id: contentColumn
      anchors.fill: parent
      anchors.margins: Style.marginS
      spacing: Style.marginS

      // Inner "card" where preview lives
      Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: Color.mSurfaceVariant || "#1a1f26"
        border.color: Color.mOutline || "#343b45"
        border.width: 1
        radius: Style.radiusS

        BusyIndicator {
          anchors.centerIn: parent
          running: loadingFullContent
          visible: loadingFullContent
          width: Style.baseWidgetSize
          height: width
        }

        Item {
          anchors.fill: parent
          anchors.margins: Style.marginS

          // Image preview
          NImageRounded {
            anchors.fill: parent
            imagePath: imageDataUrl
            visible: isImageContent && !loadingFullContent && imageDataUrl !== ""
            radius: Style.radiusS
            imageFillMode: Image.PreserveAspectFit
          }

          // Text preview
          ScrollView {
            anchors.fill: parent
            clip: true
            visible: !isImageContent && !loadingFullContent

            // IMPORTANT: prevent Qt Quick Controls default white background
            background: Rectangle { color: "transparent" }

            // Keep content off the edges
            padding: Style.marginS

            // Optional: make scrollbars match theme
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            ScrollBar.horizontal.policy: ScrollBar.AsNeeded

            TextArea {
              text: fullContent
              readOnly: true
              wrapMode: Text.Wrap
              textFormat: TextArea.RichText
              font.pointSize: Style.fontSizeM

              // Theme-consistent text
              color: Color.mOnSurface || "#e6e9ef"

              // IMPORTANT: prevent TextArea default white background
              background: Rectangle { color: "transparent" }

              // Better selection colors (so highlight doesn't look "washed out")
              selectionColor: Qt.rgba(
                                 (Color.mPrimary && Color.mPrimary.r !== undefined) ? Color.mPrimary.r : 0.25,
                                 (Color.mPrimary && Color.mPrimary.g !== undefined) ? Color.mPrimary.g : 0.55,
                                 (Color.mPrimary && Color.mPrimary.b !== undefined) ? Color.mPrimary.b : 0.95,
                                 0.35
                               )
              selectedTextColor: Color.mOnSurface || "#ffffff"
              selectByMouse: true
            }
          }
        }
      }
    }
  }
}
