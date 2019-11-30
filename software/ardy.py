# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'project.ui'
#
# Created by: PyQt5 UI code generator 5.13.0
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtWidgets import QMessageBox

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(880, 600)
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.frame = QtWidgets.QFrame(self.centralwidget)
        self.frame.setGeometry(QtCore.QRect(100, 80, 551, 361))
        font = QtGui.QFont()
        font.setPointSize(22)
        self.frame.setFont(font)
        self.frame.setFrameShape(QtWidgets.QFrame.StyledPanel)
        self.frame.setFrameShadow(QtWidgets.QFrame.Raised)
        self.frame.setObjectName("frame")
        self.id = QtWidgets.QLineEdit(self.frame)
        self.id.setGeometry(QtCore.QRect(270, 60, 181, 41))
        self.id.setText("")
        self.id.setObjectName("id")
        self.label = QtWidgets.QLabel(self.frame)
        self.label.setGeometry(QtCore.QRect(190, 60, 61, 41))
        self.label.setObjectName("label")
        self.password = QtWidgets.QLineEdit(self.frame)
        self.password.setGeometry(QtCore.QRect(270, 110, 181, 41))
        self.password.setText("")
        self.password.setObjectName("password")
        self.label_2 = QtWidgets.QLabel(self.frame)
        self.label_2.setGeometry(QtCore.QRect(60, 110, 181, 41))
        self.label_2.setObjectName("label_2")
        self.label_3 = QtWidgets.QLabel(self.frame)
        self.label_3.setGeometry(QtCore.QRect(70, 160, 161, 61))
        self.label_3.setObjectName("label_3")
        self.type_of_user = QtWidgets.QComboBox(self.frame)
        self.type_of_user.setGeometry(QtCore.QRect(270, 170, 181, 41))
        self.type_of_user.setObjectName("type_of_user")
        self.type_of_user.addItem("")
        self.type_of_user.addItem("")
        self.log_in_button = QtWidgets.QPushButton(self.frame)
        self.log_in_button.setGeometry(QtCore.QRect(180, 250, 211, 61))
        self.log_in_button.setObjectName("log_in_button")
        self.frame_for_student = QtWidgets.QFrame(self.centralwidget)
        self.frame_for_student.setGeometry(QtCore.QRect(0, 0, 881, 80))
        self.frame_for_student.setFrameShape(QtWidgets.QFrame.StyledPanel)
        self.frame_for_student.setFrameShadow(QtWidgets.QFrame.Raised)
        self.frame_for_student.setObjectName("frame_for_student")
        self.profile_student = QtWidgets.QPushButton(self.frame_for_student)
        self.profile_student.setGeometry(QtCore.QRect(0, 0, 241, 81))
        font = QtGui.QFont()
        font.setPointSize(26)
        self.profile_student.setFont(font)
        self.profile_student.setObjectName("profile_student")
        self.courses_for_student = QtWidgets.QPushButton(self.frame_for_student)
        self.courses_for_student.setGeometry(QtCore.QRect(240, 0, 241, 81))
        font = QtGui.QFont()
        font.setPointSize(26)
        self.courses_for_student.setFont(font)
        self.courses_for_student.setObjectName("courses_for_student")
        self.a7a = QtWidgets.QPushButton(self.frame_for_student)
        self.a7a.setGeometry(QtCore.QRect(480, 0, 241, 81))
        font = QtGui.QFont()
        font.setPointSize(26)
        self.a7a.setFont(font)
        self.a7a.setObjectName("a7a")
        self.log_out_button = QtWidgets.QPushButton(self.frame_for_student)
        self.log_out_button.setGeometry(QtCore.QRect(720, 0, 161, 81))
        font = QtGui.QFont()
        font.setPointSize(24)
        self.log_out_button.setFont(font)
        self.log_out_button.setObjectName("log_out_button")
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 880, 26))
        self.menubar.setObjectName("menubar")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)

        # editied here
        self.frame_for_student.hide()

        self.retranslateUi(MainWindow)
        #editied here
        self.log_in_button.clicked.connect(self.validate)
        self.log_out_button.clicked.connect(self.log_out)

        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "MainWindow"))
        self.label.setText(_translate("MainWindow", "ID:"))
        self.label_2.setText(_translate("MainWindow", "Password:"))
        self.label_3.setText(_translate("MainWindow", "log in as:"))
        self.type_of_user.setItemText(0, _translate("MainWindow", "Student"))
        self.type_of_user.setItemText(1, _translate("MainWindow", "Professor"))
        self.log_in_button.setText(_translate("MainWindow", "log in"))
        self.profile_student.setText(_translate("MainWindow", "My Profile"))
        self.courses_for_student.setText(_translate("MainWindow", "courses"))
        self.a7a.setText(_translate("MainWindow", "a7a"))
        self.log_out_button.setText(_translate("MainWindow", "log out"))

    # validate info
    def validate(self):
        id_value = self.id.text()
        password_value = self.password.text()
        user_type_value = self.type_of_user.currentText()
        #here load data of students or profssor and validate and keep data at an object of the user type
        if id_value == "1984" and password_value == "123456" and user_type_value == 'Student':
            self.frame.hide()
            self.frame_for_student.show()
            self.id.setText("")
            self.password.setText("")

        else:
            msg = QMessageBox()
            msg.setWindowTitle("login")
            msg.setText("Wrong user name or Password")
            msg.setIcon(QMessageBox.Warning)
            x = msg.exec_()

    def log_out(self):
        #empty the data first
        self.frame_for_student.hide()
        self.frame.show()
if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_MainWindow()
    ui.setupUi(MainWindow)
    MainWindow.show()
    sys.exit(app.exec_())
