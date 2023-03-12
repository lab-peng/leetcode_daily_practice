# 博彦科技初试
class Employee:
    start_salary = 10000
    def __init__(self, name, age, salary):
        self.name = name
        self.age = age
        self.salary = salary

    def __str__(self):
        return f'{self.name} is {self.age} years old'

    def salary_raise(self, amt):
        self.salary += amt

    @staticmethod
    def capitalize(name):
        return name.upper()
        
    @classmethod
    def start_salary_raise(cls, amt):
        cls.start_salary += amt

print(Employee.capitalize('zhang fei'))
Employee.start_salary_raise(2000)
e = Employee('Liu Bei', 31, 30000)
print(e.start_salary, e.salary)
print()


# 单例模式(Singleton Pattern)
class SingletonClass:
    def __new__(cls):
        if not hasattr(cls, 'instance'):
            cls.instance = super().__new__(cls)
        return cls.instance
   
singleton = SingletonClass()
new_singleton = SingletonClass()
 
print(singleton is new_singleton)
print(id(singleton), id(new_singleton))
 
singleton.color = "red"
print(new_singleton.color)

# x = (i for i in range(10))
# print(x)

# # [i for i in range(10)]


# for i in x:
#     print(i)


# mysql


# ORM object relational mapping

print()
class CEO:

    def __new__(cls, name, age, salary):
        if not hasattr(cls, 'instance'):
            cls.instance = super().__new__(cls)
            cls.instance.name = name
            cls.instance.age = age
            cls.instance.salary = salary
        else:
            print('We have one CEO already!')
        return cls.instance

ceo = CEO('Zhege Liang', 45, 200_000)
print(ceo)
ceo2 = CEO('B', 1, 2)

print(ceo is ceo2)
print(id(ceo), id(ceo2))

print(ceo.name, ceo.age, ceo.salary)
print(ceo2.name, ceo2.age, ceo2.salary)



