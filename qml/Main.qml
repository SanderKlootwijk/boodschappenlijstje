/*
 * Copyright (C) 2021  Sander Klootwijk
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * boodschappenlijstje is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import Ubuntu.Components 1.3
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'boodschappenlijstje.sanderklootwijk'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    // Hiermee wordt voorkomen dat de gebruikersinterface overlapt wordt door het toetsenbord
    anchorToKeyboard: true

    Page {
        anchors.fill: parent

        header: PageHeader {
            id: header
            title: i18n.tr('Boodschappenlijstje')
        }

        // In deze listview verschijnen straks alle ingevoerde boodschappen
        ListView {
            id: boodschappenListView

            anchors {
                left: parent.left
                right: parent.right
                top: header.bottom
                bottom: boodschappenTextField.top
                bottomMargin: units.gu(1)
            }

            // De listview leest welke boodschappen er zijn vanuit een zogenaamd listmodel
            model: boodschappenListModel

            // Door clip op true te zetten, wordt voorkomen dat de listview door andere componenten heen gaat en deze overlapt
            clip: true

            // Voor iedere boodschap die wordt toegevoegd, wordt een nieuw listitem in de listview aangemaakt
            delegate: ListItem {
                width: parent.width
                height: units.gu(5)

                // In het text element komt de naam van onze boodschap te staan
                Text {
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                        verticalCenter: parent.verticalCenter
                    }
                    
                    text: boodschap
                }
                
                // De onderstaande 'action' wordt zichtbaar wanneer de gebruiker naar links swiped op de boodschap
                leadingActions: ListItemActions {
                    actions: [
                        Action {
                            iconName: "delete"

                            // Wanneer deze action (of knop) aangetikt wordt, wordt de boodschap uit ons lijstje verwijderd
                            onTriggered: {
                                boodschappenListModel.remove(value)
                            }
                        }
                    ]
                }
            }
        }

        // Aan deze listmodel worden al onze boodschappen toegevoegd. De listview kijkt naar welke boodschappen er zijn en zet ze voor ons om in de listelements die we eerder zagen.
        ListModel {
            id: boodschappenListModel
        }

        // In dit tekstveld kunnen de boodschappen ingevoerd worden
        TextField {
            id: boodschappenTextField
            width: parent.width - toevoegButton.width - units.gu(3)
            
            anchors {
                left: parent.left
                leftMargin: units.gu(1)
                bottom: parent.bottom
                bottomMargin: units.gu(1)
            }

            

            placeholderText: "boter, kaas, eieren"
            
        }

        // Door op deze knop te drukken, wordt de boodschap toegevoegd
        Button {
            id: toevoegButton

            anchors {
                left: boodschappenTextField.right
                leftMargin: units.gu(1)
                bottom: parent.bottom
                bottomMargin: units.gu(1)
            }

            text: "Toevoegen"

            color: UbuntuColors.green

            onClicked: {
                // Eerst wordt gekeken of er wel iets in het tekstveld staat. Wanneer de tekenlengte groter is dan 0 en er dus iets staat, wordt de boodschap toegevoegd aan de listmodel en het tekstveld weer leeggemaakt voor de volgende boodschap.
                if (boodschappenTextField.length > 0) {
                    boodschappenListModel.append({boodschap: boodschappenTextField.text})
                    boodschappenTextField.text = ""
                }
                // Als er niets in het tekstveld staat, gebeurt er niets wanneer er op de knop wordt geklikt
                else {
                    
                }
            }
        }

    }
}
