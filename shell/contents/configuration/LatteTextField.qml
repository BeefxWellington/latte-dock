/*
*  Copyright 2016  Smith AR <audoban@openmailbox.org>
*                  Michail Vourlakos <mvourlakos@gmail.com>
*
*  This file is part of Latte-Dock
*
*  Latte-Dock is free software; you can redistribute it and/or
*  modify it under the terms of the GNU General Public License as
*  published by the Free Software Foundation; either version 2 of
*  the License, or (at your option) any later version.
*
*  Latte-Dock is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4

import org.kde.plasma.components 2.0 as PlasmaComponents

PlasmaComponents.TextField{
    id: textField
    validator: IntValidator {bottom: minValue; top: maxValue;}
    text: value === 0 ? "" : value
    font.italic: true
    placeholderText: i18n("<none>")

    property int step: 100
    property int value: 0

    property int minValue: 0
    property int maxValue: 3000


    function confirmValue(val){
        var fixedVal = Math.min(maxValue, val);

        if (fixedVal < minValue) {
            return minValue;
        } else {
            return fixedVal;
        }
    }

    onTextChanged: text !== "" ? value = parseInt(text) : value = 0;


    Row{
        // width: 4 * theme.defaultFont.pixelSize
        anchors.right: parent.right
        anchors.rightMargin: 2
        anchors.verticalCenter: parent.verticalCenter
        PlasmaComponents.Label{
            color: textField.textColor
            text: i18n("ms.")
            font.italic: true
            opacity: (value === 0) ? 0 : 0.6
        }
        PlasmaComponents.Label{
            text: "  "
            font.italic: true
        }
        PlasmaComponents.Button{
            width: 2*theme.defaultFont.pixelSize - 4
            height: width
            text:"-"
            onClicked: value = confirmValue(value - step);
        }
        PlasmaComponents.Button{
            width: 2*theme.defaultFont.pixelSize - 4
            height: width
            text:"+"
            onClicked: value = confirmValue(value + step);
        }
    }

    MouseArea{
        anchors.fill: parent
        acceptedButtons: Qt.MiddleButton

        onWheel: {
            var angle = wheel.angleDelta.y / 8

            if (angle>0) {
                value = confirmValue(value + step);
            } else if (angle<0){
                value = confirmValue(value - step);
            }
        }
    }

}
