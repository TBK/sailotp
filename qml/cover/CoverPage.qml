/*
 * Copyright (c) 2013, Stefan Brand <seiichiro@seiichiro0185.org>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this 
 *    list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice, this
 *    list of conditions and the following disclaimer in the documentation and/or other 
 *    materials provided with the distribution.
 * 
 * 3. The names of the contributors may not be used to endorse or promote products 
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import "../lib/crypto.js" as OTP

// Define the Layout of the Active Cover
CoverBackground {
  id: coverPage

  property double lastUpdated: 0

  Timer {
    interval: 1000
    // Timer runs only when cover is visible and favourite is set
    running: !Qt.application.active && appWin.coverSecret != ""
    repeat: true
    onTriggered: {
      // get seconds from current Date
      var curDate = new Date();

      if (lOTP.text == "" || curDate.getSeconds() == 30 || curDate.getSeconds() == 0 || (curDate.getTime() - lastUpdated > 2000)) {
        appWin.coverOTP = OTP.calcOTP(appWin.coverSecret);
      }

      // Change color of the OTP to red if less than 5 seconds left
      if (29 - (curDate.getSeconds() % 30) < 5) {
        lOTP.color = "red"
      } else {
        lOTP.color = Theme.highlightColor
      }

      lastUpdated = curDate.getTime();
    }
  }

  // Show the SailOTP Logo
  Image {
    id: logo
    source: "../sailotp.png"
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 48
  }

  Column {
    anchors.top: logo.bottom
    anchors.topMargin: 48
    anchors.horizontalCenter: parent.horizontalCenter

    Label {
      text: appWin.coverTitle
      anchors.horizontalCenter: parent.horizontalCenter
      color: Theme.secondaryColor
    }
    Label {
      id: lOTP
      text: appWin.coverOTP
      anchors.horizontalCenter: parent.horizontalCenter
      color: Theme.highlightColor
      font.pixelSize: Theme.fontSizeExtraLarge
    }
  }
}
