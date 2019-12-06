# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'project2.ui'
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
        #list of results
        self.result = []
        #lit of cources
        self.courses = []

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
        MainWindow.resize(1025, 836)
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.frame = QtWidgets.QFrame(self.centralwidget)
        self.frame.setGeometry(QtCore.QRect(210, 160, 538, 252))
        font = QtGui.QFont()
        font.setPointSize(22)
        self.frame.setFont(font)
        self.frame.setFrameShape(QtWidgets.QFrame.StyledPanel)
        self.frame.setFrameShadow(QtWidgets.QFrame.Raised)
        self.frame.setObjectName("frame")
        self.formLayout = QtWidgets.QFormLayout(self.frame)
        self.formLayout.setObjectName("formLayout")
        self.label = QtWidgets.QLabel(self.frame)
        self.label.setObjectName("label")
        self.formLayout.setWidget(0, QtWidgets.QFormLayout.LabelRole, self.label)
        self.id = QtWidgets.QLineEdit(self.frame)
        self.id.setText("")
        self.id.setObjectName("id")
        self.formLayout.setWidget(0, QtWidgets.QFormLayout.FieldRole, self.id)
        self.label_2 = QtWidgets.QLabel(self.frame)
        self.label_2.setObjectName("label_2")
        self.formLayout.setWidget(1, QtWidgets.QFormLayout.LabelRole, self.label_2)
        self.password = QtWidgets.QLineEdit(self.frame)
        self.password.setText("")
        self.password.setObjectName("password")
        self.formLayout.setWidget(1, QtWidgets.QFormLayout.FieldRole, self.password)
        self.label_3 = QtWidgets.QLabel(self.frame)
        self.label_3.setObjectName("label_3")
        self.formLayout.setWidget(2, QtWidgets.QFormLayout.LabelRole, self.label_3)
        self.type_of_user = QtWidgets.QComboBox(self.frame)
        self.type_of_user.setObjectName("type_of_user")
        self.type_of_user.addItem("")
        self.type_of_user.addItem("")
        self.formLayout.setWidget(2, QtWidgets.QFormLayout.FieldRole, self.type_of_user)
        self.log_in_button = QtWidgets.QPushButton(self.frame)
        self.log_in_button.setObjectName("log_in_button")
        self.formLayout.setWidget(3, QtWidgets.QFormLayout.SpanningRole, self.log_in_button)
        self.frame_for_student = QtWidgets.QFrame(self.centralwidget)
        self.frame_for_student.setGeometry(QtCore.QRect(50, 0, 881, 80))
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
        self.area_for_profile.setGeometry(QtCore.QRect(60, 80, 821, 621))
        font = QtGui.QFont()
        font.setPointSize(24)
        self.area_for_profile.setFont(font)
        self.area_for_profile.setFrameShape(QtWidgets.QFrame.Box)
        self.area_for_profile.setWidgetResizable(True)
        self.area_for_profile.setObjectName("area_for_profile")
        self.scrollAreaWidgetContents = QtWidgets.QWidget()
        self.scrollAreaWidgetContents.setGeometry(QtCore.QRect(0, 0, 817, 617))
        self.scrollAreaWidgetContents.setObjectName("scrollAreaWidgetContents")
        self.label_4 = QtWidgets.QLabel(self.scrollAreaWidgetContents)
        self.label_4.setGeometry(QtCore.QRect(220, 110, 581, 51))
        font = QtGui.QFont()
        font.setPointSize(26)
        self.label_4.setFont(font)
        self.label_4.setObjectName("label_4")
        self.label_5 = QtWidgets.QLabel(self.scrollAreaWidgetContents)
        self.label_5.setGeometry(QtCore.QRect(80, 160, 731, 51))
        font = QtGui.QFont()
        font.setPointSize(26)
        self.label_5.setFont(font)
        self.label_5.setObjectName("label_5")
        self.label_6 = QtWidgets.QLabel(self.scrollAreaWidgetContents)
        self.label_6.setGeometry(QtCore.QRect(160, 60, 641, 41))
        self.label_6.setObjectName("label_6")
        self.label_7 = QtWidgets.QLabel(self.scrollAreaWidgetContents)
        self.label_7.setGeometry(QtCore.QRect(160, 220, 641, 41))
        self.label_7.setObjectName("label_7")
        self.label_8 = QtWidgets.QLabel(self.scrollAreaWidgetContents)
        self.label_8.setGeometry(QtCore.QRect(180, 280, 621, 41))
        self.label_8.setObjectName("label_8")
        self.label_9 = QtWidgets.QLabel(self.scrollAreaWidgetContents)
        self.label_9.setGeometry(QtCore.QRect(130, 330, 641, 41))
        self.label_9.setObjectName("label_9")
        self.line = QtWidgets.QFrame(self.scrollAreaWidgetContents)
        self.line.setGeometry(QtCore.QRect(20, 80, 781, 61))
        self.line.setFrameShadow(QtWidgets.QFrame.Plain)
        self.line.setLineWidth(1)
        self.line.setFrameShape(QtWidgets.QFrame.HLine)
        self.line.setObjectName("line")
        self.line_2 = QtWidgets.QFrame(self.scrollAreaWidgetContents)
        self.line_2.setGeometry(QtCore.QRect(20, 130, 781, 61))
        self.line_2.setFrameShadow(QtWidgets.QFrame.Plain)
        self.line_2.setLineWidth(1)
        self.line_2.setFrameShape(QtWidgets.QFrame.HLine)
        self.line_2.setObjectName("line_2")
        self.line_3 = QtWidgets.QFrame(self.scrollAreaWidgetContents)
        self.line_3.setGeometry(QtCore.QRect(20, 190, 781, 61))
        self.line_3.setFrameShadow(QtWidgets.QFrame.Plain)
        self.line_3.setLineWidth(1)
        self.line_3.setFrameShape(QtWidgets.QFrame.HLine)
        self.line_3.setObjectName("line_3")
        self.line_4 = QtWidgets.QFrame(self.scrollAreaWidgetContents)
        self.line_4.setGeometry(QtCore.QRect(20, 240, 781, 61))
        self.line_4.setFrameShadow(QtWidgets.QFrame.Plain)
        self.line_4.setLineWidth(1)
        self.line_4.setFrameShape(QtWidgets.QFrame.HLine)
        self.line_4.setObjectName("line_4")
        self.line_5 = QtWidgets.QFrame(self.scrollAreaWidgetContents)
        self.line_5.setGeometry(QtCore.QRect(20, 300, 781, 61))
        self.line_5.setFrameShadow(QtWidgets.QFrame.Plain)
        self.line_5.setLineWidth(1)
        self.line_5.setFrameShape(QtWidgets.QFrame.HLine)
        self.line_5.setObjectName("line_5")
        self.line_6 = QtWidgets.QFrame(self.scrollAreaWidgetContents)
        self.line_6.setGeometry(QtCore.QRect(20, 350, 781, 61))
        self.line_6.setFrameShadow(QtWidgets.QFrame.Plain)
        self.line_6.setLineWidth(1)
        self.line_6.setFrameShape(QtWidgets.QFrame.HLine)
        self.line_6.setObjectName("line_6")
        self.area_for_profile.setWidget(self.scrollAreaWidgetContents)
        self.area_for_stu_courses = QtWidgets.QScrollArea(self.centralwidget)
        self.area_for_stu_courses.setGeometry(QtCore.QRect(40, 80, 931, 621))
        self.area_for_stu_courses.setWidgetResizable(True)
        self.area_for_stu_courses.setObjectName("area_for_stu_courses")
        self.scrollAreaWidgetContents_5 = QtWidgets.QWidget()
        self.scrollAreaWidgetContents_5.setGeometry(QtCore.QRect(0, 0, 929, 619))
        self.scrollAreaWidgetContents_5.setObjectName("scrollAreaWidgetContents_5")
        self.sel_course_stu = QtWidgets.QComboBox(self.scrollAreaWidgetContents_5)
        self.sel_course_stu.setGeometry(QtCore.QRect(290, 40, 331, 41))
        font = QtGui.QFont()
        font.setPointSize(22)
        self.sel_course_stu.setFont(font)
        self.sel_course_stu.setObjectName("sel_course_stu")
        self.sel_course_stu.addItem("")
        self.view_course = QtWidgets.QPushButton(self.scrollAreaWidgetContents_5)
        self.view_course.setGeometry(QtCore.QRect(370, 100, 181, 61))
        font = QtGui.QFont()
        font.setPointSize(18)
        self.view_course.setFont(font)
        self.view_course.setObjectName("view_course")
        self.table_for_stu = QtWidgets.QTableWidget(self.scrollAreaWidgetContents_5)
        self.table_for_stu.setGeometry(QtCore.QRect(70, 190, 791, 71))
        self.table_for_stu.setRowCount(1)
        self.table_for_stu.setColumnCount(5)
        self.table_for_stu.setObjectName("table_for_stu")
        item = QtWidgets.QTableWidgetItem()
        self.table_for_stu.setVerticalHeaderItem(0, item)
        item = QtWidgets.QTableWidgetItem()
        self.table_for_stu.setHorizontalHeaderItem(0, item)
        item = QtWidgets.QTableWidgetItem()
        self.table_for_stu.setHorizontalHeaderItem(1, item)
        item = QtWidgets.QTableWidgetItem()
        self.table_for_stu.setHorizontalHeaderItem(2, item)
        item = QtWidgets.QTableWidgetItem()
        self.table_for_stu.setHorizontalHeaderItem(3, item)
        item = QtWidgets.QTableWidgetItem()
        self.table_for_stu.setHorizontalHeaderItem(4, item)
        self.area_for_stu_courses.setWidget(self.scrollAreaWidgetContents_5)
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 1025, 26))
        self.menubar.setObjectName("menubar")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)

        item = QtWidgets.QTableWidgetItem()
        self.table_for_stu.setItem(0, 0, item)
        item = QtWidgets.QTableWidgetItem()
        self.table_for_stu.setItem(0, 1, item)
        item = QtWidgets.QTableWidgetItem()
        self.table_for_stu.setItem(0, 2, item)
        item = QtWidgets.QTableWidgetItem()
        self.table_for_stu.setItem(0, 3, item)
        item = QtWidgets.QTableWidgetItem()
        self.table_for_stu.setItem(0, 4, item)

        self.session = Session()

        self.frame_for_student.hide()
        self.area_for_profile.hide()
        self.area_for_stu_courses.hide()

        self.retranslateUi(MainWindow)
        self.log_in_button.clicked.connect(self.validate)
        self.log_out_button.clicked.connect(self.log_out)
        self.profile_student.clicked.connect(self.my_profile_func)
        self.courses_for_student.clicked.connect(self.courses_stu)
        self.view_course.clicked.connect(self.view)

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
        self.label_6.setText(_translate("MainWindow", "Name:"))
        self.label_7.setText(_translate("MainWindow", "Major:"))
        self.label_8.setText(_translate("MainWindow", "year:"))
        self.label_9.setText(_translate("MainWindow", "Gender:"))
        self.sel_course_stu.setItemText(0, _translate("MainWindow", "select course"))
        self.view_course.setText(_translate("MainWindow", "View course"))
        item = self.table_for_stu.verticalHeaderItem(0)
        item.setText(_translate("MainWindow", "Name"))
        item = self.table_for_stu.horizontalHeaderItem(0)
        item.setText(_translate("MainWindow", "MidtermResult"))
        item = self.table_for_stu.horizontalHeaderItem(1)
        item.setText(_translate("MainWindow", "Attendence"))
        item = self.table_for_stu.horizontalHeaderItem(2)
        item.setText(_translate("MainWindow", "Project"))
        item = self.table_for_stu.horizontalHeaderItem(3)
        item.setText(_translate("MainWindow", "assigiment"))
        item = self.table_for_stu.horizontalHeaderItem(4)
        item.setText(_translate("MainWindow", "final"))

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


            students = DataBaseTable('students.csv')

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
                    # self.session.student.result.midterm = students.file.iloc[i]['MidtermResult']
                    # self.session.student.result.project = students.file.iloc[i]['Project']
                    # self.session.student.result.attendance = students.file.iloc[i]['Attendence']
                    # self.session.student.result.midterm = students.file.iloc[i]['final']
                    self.session.student.courses = students.file.iloc[i]['cources'].split('-')
                    #print(self.session.student.cources)

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
        self.area_for_stu_courses.hide()
        self.frame_for_student.hide()
        self.frame.show()
        self.area_for_profile.hide()
        cs = self.session.student.courses
        try:
            for i in range(len(cs)):
                self.sel_course_stu.removeItem(1)
        except:
            pass

    def my_profile_func(self):
        self.area_for_stu_courses.hide()
        self.area_for_profile.show()
        self.label_4.setText('ID: ' + str(self.session.student.id))
        self.label_5.setText('Password: ' + str(self.session.student.password))
        self.label_6.setText('Name: ' + str(self.session.student.name))
        self.label_7.setText('Major: ' + str(self.session.student.major))
        self.label_8.setText('Year: ' + str(self.session.student.year))
        self.label_9.setText('Gender: ' + str(self.session.student.Gender))
        try:
            cs = self.session.student.courses
            for i in range(len(cs)):
                self.sel_course_stu.removeItem(1)
        except:
            pass

    def courses_stu(self):
        self.area_for_stu_courses.show()
        self.area_for_profile.hide()
        self.sel_course_stu.setCurrentIndex(0)
        cs = self.session.student.courses
        for cou in cs:
            self.sel_course_stu.addItem(cou)

        item = self.table_for_stu.verticalHeaderItem(0)
        item.setText("Name")

        item = self.table_for_stu.item(0, 0)
        item.setText("")

        item = self.table_for_stu.item(0, 1)
        item.setText("")

        item = self.table_for_stu.item(0, 2)
        item.setText("")

        item = self.table_for_stu.item(0, 3)
        item.setText("")

        item = self.table_for_stu.item(0, 4)
        item.setText("")

        try:
            cs = self.session.student.courses
            for i in range(len(cs)):
                self.sel_course_stu.removeItem(3)
        except:
            pass


    def view(self):

        requested_course = self.sel_course_stu.currentText()
        if (requested_course != 'select course'):
            course = DataBaseTable(requested_course+".csv")
            course.file = course.file.set_index('studentID')
            item = self.table_for_stu.verticalHeaderItem(0)
            item.setText(self.session.student.name)
            # item = QtWidgets.QTableWidgetItem()
            # self.table_for_stu.setItem(0, 0, item)
            # item = QtWidgets.QTableWidgetItem()
            # self.table_for_stu.setItem(0, 1, item)
            # item = QtWidgets.QTableWidgetItem()
            # self.table_for_stu.setItem(0, 2, item)
            # item = QtWidgets.QTableWidgetItem()
            # self.table_for_stu.setItem(0, 3, item)
            # item = QtWidgets.QTableWidgetItem()
            # self.table_for_stu.setItem(0, 4, item)

            item = self.table_for_stu.item(0,0)
            item.setText(str(course.file['MidtermResult'][self.session.student.id]))

            item = self.table_for_stu.item(0, 1)
            item.setText(str(course.file['Attendence'][self.session.student.id]))

            item = self.table_for_stu.item(0, 2)
            item.setText(str(course.file['Project'][self.session.student.id]))

            item = self.table_for_stu.item(0, 3)
            item.setText(str(course.file['assigiment'][self.session.student.id]))

            item = self.table_for_stu.item(0, 4)
            item.setText(str(course.file['final'][self.session.student.id]))



            #for i in range(5):



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
