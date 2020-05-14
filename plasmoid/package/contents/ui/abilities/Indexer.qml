/*
*  Copyright 2020 Michail Vourlakos <mvourlakos@gmail.com>
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

import org.kde.plasma.plasmoid 2.0

import org.kde.latte.abilities.applets 0.1 as AppletAbility

AppletAbility.Indexer {
    id: _indexer
    property Item layout: null   

    readonly property bool tailAppletIsSeparator: isActive ? bridge.indexer.tailAppletIsSeparator : false
    readonly property bool headAppletIsSeparator: isActive ? bridge.indexer.headAppletIsSeparator : false

    readonly property int visibleItemsCount: Math.max(0, layout.children.length - separators.length - hidden.length)

    readonly property int maxIndex: 99999

    property int allItemsCount: 0 /*is needed to be set from consumer developer in order to avoid binding loops warnings*/

    property int firstVisibleItemIndex: -1
    property int lastVisibleItemIndex: -1

    Binding {
        target: _indexer
        property: "firstVisibleItemIndex"
        when: layout.children.length >= allItemsCount
        value: {
            var ind = maxIndex;
            for(var i=0; i<layout.children.length; ++i) {
                var item = layout.children[i];
                if (item && item.itemIndex>=0
                        && hidden.indexOf(item.itemIndex)<0
                        && separators.indexOf(item.itemIndex)<0
                        && item.itemIndex < ind) {
                    ind = item.itemIndex;
                }
            }

            return ind === maxIndex ? -1 : ind;
        }
    }

    Binding {
        target: _indexer
        property: "lastVisibleItemIndex"
        when: layout.children.length >= allItemsCount
        value: {
            var ind = -1;

            for(var i=0; i<layout.children.length; ++i) {
                var item = layout.children[i];
                if (item && item.itemIndex>=0
                        && hidden.indexOf(item.itemIndex)<0
                        && separators.indexOf(item.itemIndex)<0
                        && item.itemIndex > ind) {

                    //console.log("org.kde.latte SETTING UP ::: " + item.itemIndex + " / " + layout.children.length);
                    ind = item.itemIndex;
                }
            }

            return ind;
        }
    }

    readonly property bool firstTailItemIsSeparator: {
        if (visibleItemsCount === layout.children.length) {
            return false;
        }

        for(var i=0; i<firstVisibleItemIndex; ++i) {
            if (separators.indexOf(i)>=0) {
                return true;
            }
        }

        return false;
    }

    readonly property bool lastHeadItemIsSeparator: {
        if (visibleItemsCount === layout.children.length) {
            return false;
        }

        var len = layout.children.length;

        for(var i=len-1; i>lastVisibleItemIndex; --i) {
            if (separators.indexOf(i)>=0) {
                return true;
            }
        }

        return false;
    }

    separators: {
        var seps = [];

        for (var i=0; i<layout.children.length; ++i){
            var item = layout.children[i];
            if (item && item.isSeparator && item.itemIndex>=0) {
                seps.push(item.itemIndex);
            }
        }

        return seps;
    }

    hidden: {
        var hdns = [];

        for (var i=0; i<layout.children.length; ++i){
            var item = layout.children[i];
            if (item && item.isHidden && item.itemIndex>=0) {
                hdns.push(item.itemIndex);
            }
        }

        return hdns;
    }

}