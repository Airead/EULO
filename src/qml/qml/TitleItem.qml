﻿import QtQuick 2.10
import QtQuick.Window 2.3
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.3
import QtQuick.Controls.Material.impl 2.3
import QtQuick.Controls 1.4 as Controls_1_4
import QtQuick.Controls.Styles 1.4 as Controls_1_4_style
import QtGraphicalEffects 1.0
import QtQuick.Dialogs 1.3

import "../qml/app_pages"
import "./app_items"
import "./base_items"
import "../qml/app_dialogs"

Rectangle{
    id:title

    color:"#1E5569"
    radius: radius_all == undefined ? 1:(radius_all>1?radius_all-1:0)
    property alias maximum_btn: maximum_btn
    property alias coinTypeBtn: coin_type_btn
    property alias naviPanel: naviPanel
    property alias optionsDialog: optionsDialog

    objectName: "title"
    property bool opened: help_menu.opened || coin_type_btn.opened ||tool_menu.opened|| set_menu.opened ||file_menu.opened

    MouseArea{
        anchors.fill: parent
        property var clickPos

        onPressed: {
            clickPos = { x: mouse.x, y: mouse.y }

        }
        onPositionChanged: {

            root_window.x = mousePosition.cursorPos().x - clickPos.x - background.x
            root_window.y = mousePosition.cursorPos().y - clickPos.y - background.y
        }

    }




    Image{
        id:logo_img
        source: "qrc:/images/icons/logo.png"
        fillMode: Image.PreserveAspectFit
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 20
        width:170
    }


    CommonMenuButton
    {
        id:help_menu
        text: qsTr("Help")
        anchors.right:  minimum_btnRect.left
        anchors.rightMargin:    10
        anchors.verticalCenter: minimum_btnRect.verticalCenter
        contentWidth:140
        model: ListModel
        {
            ListElement { modelData: qsTr("Command-line options"); }
            ListElement { modelData: qsTr("About EULO Core"); }
            ListElement { modelData: qsTr("About Qt"); }
        }


        onHoveredChanged:
        {
            if(hovered && (set_menu.opened || tool_menu.opened || file_menu.opened))
            {
                set_menu.close_popup()
                tool_menu.close_popup()
                file_menu.close_popup()

                clicked()
            }
        }

        onMenu_triggered:
        {
            switch (index)
            {
            case 0:helpDialog.show();break;
            case 1:aboutDialog.show();break;
            case 2:utility.aboutQt();break;//TODO: find a way to get aboutQt info as QString, and make a shadowed dialog to display this message


            default:break;

            }

        }


    }

    CommonMenuButton
    {
        id:tool_menu
        text: "T工具"
        anchors.right:  help_menu.left
        anchors.rightMargin:    3
        anchors.verticalCenter: minimum_btnRect.verticalCenter
        contentWidth:130
        property bool fisrt_run: true

        model: ListModel
        {
            ListElement { modelData: "I信息"; }
            ListElement { modelData: "D调试控制台"; }
            ListElement { modelData: "N网络监视器"; }
            ListElement { modelData: "P并列列表"; }
            ListElement { modelData: "W钱包修复"; }
            ListElement { modelData: "打开钱包配置文件"; }
            ListElement { modelData: "打开主节点配置文件"; }
            ListElement { modelData: "显示自动备份"; }
            ListElement { modelData: "区块浏览器"; }


        }

        onHoveredChanged:
        {
            if(hovered && (help_menu.opened || set_menu.opened || file_menu.opened))
            {
                help_menu.close_popup()
                set_menu.close_popup()
                file_menu.close_popup()

                clicked()
            }
        }

        onMenu_triggered:
        {
            switch (index)
            {
            case 0:toolsDialog.show();toolsDialog.current_index=0;break;
            case 1:toolsDialog.show();toolsDialog.current_index=1;break;
            case 2:toolsDialog.show();toolsDialog.current_index=2;break;
            case 3:toolsDialog.show();toolsDialog.current_index=3;break;
            case 4:toolsDialog.show();toolsDialog.current_index=4;break;
            case 5:rpcConsole.showConfEditor(); break;
            case 6:rpcConsole.showMNConfEditor();break;
            case 7:rpcConsole.showBackups();break;
            case 8:
            {

                if(fisrt_run && !blockExplorer.isTxindexSet())
                {
                    fisrt_run = false
                    firstrun_dialog.show()
                }else
                {
                    blockExplorerDialog.show();
                }

                break;
            }

            default:break;

            }

        }

        CommonDialog
        {
            id:firstrun_dialog
            title: "Notice"
            confrim_btn_text: "Ok"
            cancel_btn_visible: false
            close_btnRect_visible: false
            content_text: "Not all transactions will be shown. To view all transactions you need to set txindex=1 in the configuration file (eulo.conf)."
            width:480
            height: 200
            modality: Qt.WindowModal
            onConfirmed:
            {
              firstrun_dialog.close()
              blockExplorerDialog.show();

            }

        }


    }

    CommonMenuButton
    {
        id:set_menu
        text: "S设置"
        anchors.right:  tool_menu.left
        anchors.rightMargin:    3
        anchors.verticalCenter: minimum_btnRect.verticalCenter
        contentWidth:120
        model: ListModel
        {
            ListElement { modelData: "E加密钱包"; }
            ListElement { modelData: "C修改密码"; }
            ListElement { modelData: "BIP38工具"; }
            ListElement { modelData: "M多重发送"; }
            ListElement { modelData: "Q选项"; }

        }





        onMenu_triggered:
        {
            switch (index)
            {
            case 4:optionsDialog.show();break;
            default:break;

            }

        }

        onHoveredChanged:
        {
            if(hovered && (help_menu.opened || tool_menu.opened || file_menu.opened))
            {
                help_menu.close_popup()
                tool_menu.close_popup()
                file_menu.close_popup()

                clicked()
            }
        }
    }

    CommonMenuButton
    {
        id:file_menu
        text: "F文件"
        anchors.right:  set_menu.left
        anchors.rightMargin:    3
        anchors.verticalCenter: minimum_btnRect.verticalCenter
        contentWidth:160
        model: ListModel
        {
            ListElement { modelData: "O打开URL"; }
            ListElement { modelData: "B备份钱包"; }
            ListElement { modelData: "S签名消息"; }
            ListElement { modelData: "验证消息"; }
            ListElement { modelData: "S发送地址"; }
            ListElement { modelData: "R接收地址"; }
            ListElement { modelData: "Multisignature creation"; }
            ListElement { modelData: "Multisignature spending"; }
            ListElement { modelData: "Multisignature signing"; }

        }

        onHoveredChanged:
        {
            if(hovered && (help_menu.opened || tool_menu.opened || set_menu.opened))
            {
                help_menu.close_popup()
                tool_menu.close_popup()
                set_menu.close_popup()

                clicked()
            }
        }

        onMenu_triggered:
        {
            switch (index)
            {
            case 0:open_url_dialog.show();break;
            case 1:backup_dialog.open();break;
            case 2:signInfoDialog.current_index=0;signInfoDialog.show();break;
            case 3:signInfoDialog.current_index=1;signInfoDialog.show();break;
            case 4:sendAddressDialog.show();break;
            case 5:receiveAddressDialog.show();break;
            case 6:multiSignAddressInterDialog.show();multiSignAddressInterDialog.current_index=0;break;
            case 7:multiSignAddressInterDialog.show();multiSignAddressInterDialog.current_index=1;break;
            case 8:multiSignAddressInterDialog.show();multiSignAddressInterDialog.current_index=2;break;



            default:break;

            }

        }


    }

    CommonDialog
    {
        id:open_url_dialog
        title: "Open  URI"
        confrim_btn_text: "Yes"
        cancel_btn_text: "Cancel"

        Item{
            parent:open_url_dialog.background_rec
            anchors.fill: parent


            Label
            {
                id:url_label
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.top:parent.top
                anchors.topMargin: 60
                font.letterSpacing: 0.355
                font.weight: Font.Normal
                text:"URI:"

            }

            CommonTextField
            {
                id:url_textFiled
                font.weight: Font.Medium
                font.pixelSize:13
                anchors.left: url_label.right
                anchors.leftMargin: 2
                anchors.right: url_image_btn.left
                anchors.verticalCenter: url_label.verticalCenter
            }

            CommonImageButton
            {
                id:url_image_btn
                width:40
                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.verticalCenter: url_label.verticalCenter
                source: "qrc:/images/icons/more.png"

                onClicked:
                {
                    file_dialog.open()
                }

            }

            FileDialog {
                id:file_dialog

                onAccepted:
                {
                    url_textFiled.text = fileUrl.toString().replace("file:///","")
                    url_textFiled.cursorPosition = 0
                }
            }
        }

    }

    FileDialog
    {
        id:backup_dialog

        onAccepted:
        {

        }
    }


    SignInfoDialog
    {
        id:signInfoDialog
    }

    MultiSignAddressInterDialog
    {
        id:multiSignAddressInterDialog
    }

    ReceiveAddressDialog
    {
        id:receiveAddressDialog
    }

    SendAddressDialog
    {
        id:sendAddressDialog
    }

    ToolsDialog
    {
        id:toolsDialog
    }

    HelpDialog
    {
        id:helpDialog
    }

    AboutDialog
    {
        id:aboutDialog
    }

    OptionsDialog
    {
        id:optionsDialog
    }

    BlockExplorerDialog
    {
        id:blockExplorerDialog
    }

    Rectangle
    {
        id: close_btnRect
        color: Qt.rgba(0,0,0,0)
        width:28
        height:28
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.topMargin: 5
        anchors.top:parent.top

        PropertyAnimation {id: animateColor_in; target: close_btnRect; properties: "color"; to: "#EE637F"; duration: 200}
        PropertyAnimation {id: animateColor_out; target: close_btnRect; properties: "color"; to: Qt.rgba(0,0,0,0); duration: 200}

        Image{
            id:close_btn
            source: "qrc:/images/icons/mainwindow_close.png"
            width:15
            height:15
            anchors.centerIn: parent
        }




        MouseArea{
            anchors.fill: parent
            hoverEnabled:true

            onClicked:
            {
                exit_dialog.show()
            }
            onEntered:
            {
                animateColor_in.start()
            }
            onExited:
            {
                animateColor_out.start()
            }
        }
    }

    Rectangle
    {
        id: maximum_btnRect
        color: Qt.rgba(0,0,0,0)
        width:28
        height:28
        anchors.right: close_btnRect.left
        anchors.rightMargin: 5
        anchors.top:parent.top
        anchors.topMargin: 5

        PropertyAnimation {id: animateColor_in_1; target: maximum_btnRect; properties: "color"; to: "#7B11353E"; duration: 200}
        PropertyAnimation {id: animateColor_out_1; target: maximum_btnRect; properties: "color"; to: Qt.rgba(0,0,0,0); duration: 200}

        Image{
            id:maximum_btn
            source: "qrc:/images/icons/mainwindow_maximum.png"
            width:15
            height:15
            anchors.centerIn: parent
        }

        MouseArea{
            anchors.fill: parent
            hoverEnabled:true

            onClicked: {
                if(is_Maximized){
                    root_window.showNormal()
                }
                else{
                    root_window.showMaximized()
                }
            }

            onEntered: {
                animateColor_in_1.start()
            }

            onExited: {
                animateColor_out_1.start()
            }
        }

    }


    Rectangle{
        id: minimum_btnRect
        color: Qt.rgba(0,0,0,0)
        width:28
        height:28
        anchors.right: maximum_btnRect.left
        anchors.rightMargin: 5
        anchors.top:parent.top
        anchors.topMargin: 5

        PropertyAnimation {id: animateColor_in_; target: minimum_btnRect; properties: "color"; to: "#7B11353E"; duration: 200}
        PropertyAnimation {id: animateColor_out_; target: minimum_btnRect; properties: "color"; to: Qt.rgba(0,0,0,0); duration: 200}

        Image{
            id:minimum_btn
            source: "qrc:/images/icons/mainwindow_minimum.png"
            width:15
            height:15
            anchors.centerIn: parent
            fillMode: Image.PreserveAspectFit
        }

        MouseArea{
            anchors.fill: parent
            hoverEnabled:true

            onClicked: {
                root_window.showMinimized()
            }

            onEntered: {
                animateColor_in_.start()
            }

            onExited: {
                animateColor_out_.start()
            }
        }

    }


    Rectangle{
        x:0
        y:title.height-10
        height:10
        width:parent.width
        color:"#1E5569"
    }

    //            Rectangle{
    //                id:cover_line
    //                x:0
    //                y:title.height
    //                height:1
    //                width:parent.width
    //                color:"#EDEDED"
    //            }

    Label
    {
        id:balance_label
        font.weight: Font.Normal
        font.pixelSize:15
        anchors.right: coin_type_btn.left
        anchors.rightMargin: 160
        anchors.verticalCenter: coin_type_btn.verticalCenter
        color: "#FFFFFF"
        text:"余额:"
    }

    Label
    {
        id:balance_amount_label
        font.weight: Font.Normal
        font.pixelSize:15
        anchors.left: balance_label.right
        anchors.leftMargin: 10
        anchors.verticalCenter: coin_type_btn.verticalCenter
        color: "#FFFFFF"
        text:"----"
    }


    Connections
    {
        target:walletModel

        onBalanceChanged:
        {
            balance_amount_label.text = walletModel.formatAmount(balance)
        }

    }


    NaviPanel
    {
        id:naviPanel
        anchors.centerIn: parent
    }






    CoinTypeCoin
    {
        id:coin_type_btn
        color: "#32788B"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 32
        anchors.bottomMargin: 10
        width: 75
        height: 25
        spacer_visibility: true
        property bool startSet: false

        Component.onCompleted:
        {

            switch (index = optionsModel.getDisplayUnit())
            {
            case 0:unitName = "  ULO";break;
            case 1:unitName = "  mULO";break;
            case 2:unitName = "  μULO";break;
            }

            coin_type_btn.text = unitName.trim()

            startSet = true


        }

        onIndexChanged:
        {
            if(!startSet)
                return

            switch (index)
            {
            case 0:unitName = "  ULO";break;
            case 1:unitName = "  mULO";break;
            case 2:unitName = "  μULO";break;
            }


            optionsModel.setDisplayUnit(index);
        }

    }

}