# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'project.ui'
#
# Created by: PyQt5 UI code generator 5.13.0
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtWidgets import QMessageBox

import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sb

class Person():
    def __init__(self):
        self.name = ""
        self.id = ""
        self.password = ""

    #make an virtual function here so it can be an abstract class


class Course():
    def __init__(self,name,course_id,max='150',midterm='20',attendance='5',project='15',assigiment='5'):
        #name of coruse
        self.name = name
        self.max = max()
        self.midterm = midterm
        self.attendance = attendance
        self.project = project
        self.assigiment = assigiment
        self.course_id = course_id

    #add functions here


class Result():
    def __init__(self):
        self.midterm = 0
        self.attendance = 0
        self.project = 0
        self.final = 0
        self.bonus = 0
        self.assigiment = 0
        # the state of passed or not
        self.status = False
    def CalculateTotal(self,course):
        if (self.midterm + self.attendance + self.project + self.final + self.bonus + self.assigments) > course.max :
            return course.max
        else:
            return self.midterm + self.attendance + self.project + self.final + self.bonus

    def checkStatus(self, minmum_degree ):
        if (self.CalculateTotal() >= minmum_degree):
            return "Passed"
        else:
            return "Failed"


class Student(Person):
    def __init__(self):
        Person.__init__(self)
        self.major = ""
        self.year = ""
        self.Gender = ""
        self.result = Result()

    #edit some functions later
    def addBonus(self,number):
        self.result.bonus = number

class Professor(Person):
    def __init__(self):
        Person.__init__(self)
        self.department = ""
        self.courses = []

    #add functions here

class Credentials():
    def __init__(self):
        self.id = ""
        self.password = ""
        self.type = ""
    def __eq__(self, other):
        if not isinstance(other,Credentials):
            return NotImplemented
        else:
            return (self.id == other.id) and (self.password == other.password) and (self.type == other.type)

class DataBaseTable():
    def __init__(self, path):
        self.file = pd.read_csv(path)
        self.rows = self.file.shape[0]
        self.cols = self.file.shape[1]


#to keep data of the logged in
class Session():
    def __init__(self):
        self.student = Student()
        self.professor = Professor()
        self.type = ""


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
        self.area_for_profile = QtWidgets.QScrollArea(self.centralwidget)
        self.area_for_profile.setGeometry(QtCore.QRect(70, 80, 631, 421))
        self.area_for_profile.setWidgetResizable(True)
        self.area_for_profile.setObjectName("area_for_profile")
        self.scrollAreaWidgetContents = QtWidgets.QWidget()
        self.scrollAreaWidgetContents.setGeometry(QtCore.QRect(0, 0, 629, 419))
        self.scrollAreaWidgetContents.setObjectName("scrollAreaWidgetContents")
        self.label_4 = QtWidgets.QLabel(self.scrollAreaWidgetContents)
        self.label_4.setGeometry(QtCore.QRect(220, 100, 451, 51))
        font = QtGui.QFont()
        font.setPointSize(26)
        self.label_4.setFont(font)
        self.label_4.setObjectName("label_4")
        self.label_5 = QtWidgets.QLabel(self.scrollAreaWidgetContents)
        self.label_5.setGeometry(QtCore.QRect(80, 150, 481, 51))
        font = QtGui.QFont()
        font.setPointSize(26)
        self.label_5.setFont(font)
        self.label_5.setObjectName("label_5")
        self.area_for_profile.setWidget(self.scrollAreaWidgetContents)
        self.frame_for_student.raise_()
        self.frame.raise_()
        self.area_for_profile.raise_()
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 880, 26))
        self.menubar.setObjectName("menubar")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)


        # editied here

        self.session = Session()

        self.frame_for_student.hide()
        self.area_for_profile.hide()

        self.retranslateUi(MainWindow)

        self.log_in_button.clicked.connect(self.validate)
        self.log_out_button.clicked.connect(self.log_out)
        self.profile_student.clicked.connect(self.my_profile_func)

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
        self.label_4.setText(_translate("MainWindow", "ID:"))
        self.label_5.setText(_translate("MainWindow", "Password:"))

    # validate info
    def validate(self):
        # get data from inputs and use class Credentials
        credentials = Credentials()
        credentials.id = self.id.text()
        credentials.password = self.password.text()
        credentials.type = self.type_of_user.currentText()
        print(credentials.type)
        #print('ok')
        # load student and professors tables
        # for now use course1 as sheet for students until we make the bigger sheet
        exist = False
        if (credentials.type == 'Student'):


            students = DataBaseTable('course1.csv')

            #print(students.file.iloc[0]['ID'] == credentials.id)


            for i in range(students.rows):
                #print('hello')
                if ( str(students.file.iloc[i]['ID']) == credentials.id) and (str(students.file.iloc[i]['Password']) == credentials.password):
                    exist = True
                    print(exist)
                    self.session.type = "Student"
                    self.session.student.name = students.file.iloc[i]['StudentName']
                    self.session.student.id = students.file.iloc[i]['ID']
                    self.session.student.password = students.file.iloc[i]['Password']
                    self.session.student.major = students.file.iloc[i]['major']
                    self.session.student.year = students.file.iloc[i]['year']
                    self.session.student.Gender = students.file.iloc[i]['Gender']
                    self.session.student.result.midterm = students.file.iloc[i]['MidtermResult']
                    self.session.student.result.project = students.file.iloc[i]['Project']
                    self.session.student.result.attendance = students.file.iloc[i]['Attendence']
                    self.session.student.result.midterm = students.file.iloc[i]['final']


                    self.frame.hide()
                    self.frame_for_student.show()
                    self.id.setText("")
                    self.password.setText("")

            if(exist == False):
                msg = QMessageBox()
                msg.setWindowTitle("login")
                msg.setText("Wrong ID or Password")
                msg.setIcon(QMessageBox.Warning)
                x = msg.exec_()
        else:

            professors = DataBaseTable('Professors.csv')

            for i in range(professors.rows):
                if(str(professors.file.iloc[i]['ID']) == credentials.id ) and (str(professors.file.iloc[i]['Password']) == credentials.password):
                    exist = True
                    self.session.type = "Professor"
                    self.session.professor.name = str(professors.file.iloc[i]['Name'])
                    self.session.professor.id = str(professors.file.iloc[i]['ID'])
                    self.session.professor.password = str(professors.file.iloc[i]['Password'])
                    self.session.professor.department = str(professors.file.iloc[i]['Department'])
                    cources = DataBaseTable('courses.csv')
                    for j in range(cources.rows):
                        if (str(cources.file.iloc[j]['Professor_ID']) == str(self.session.professor.id)):
                            self.session.professor.courses.append(str(cources.file.iloc[j]['Name']))

                    self.frame.hide()

                    self.id.setText("")
                    self.password.setText("")

            if (exist == False):
                msg = QMessageBox()
                msg.setWindowTitle("login")
                msg.setText("Wrong ID or Password")
                msg.setIcon(QMessageBox.Warning)
                x = msg.exec_()


    def log_out(self):
        #empty the data first
        self.frame_for_student.hide()
        self.frame.show()
        self.area_for_profile.hide()
    def my_profile_func(self):
        self.area_for_profile.show()
        self.label_4.setText('ID: ')
        self.label_5.setText('Password: ' + str(123456))


def exception_hook(exctype, value, traceback):
    print(exctype, value, traceback)
    sys._excepthook(exctype, value, traceback)
    sys.exit(1)


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_MainWindow()
    ui.setupUi(MainWindow)
    MainWindow.show()
    sys._excepthook = sys.excepthook
    sys.excepthook = exception_hook
    sys.exit(app.exec_())
