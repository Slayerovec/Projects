import mysql.connector
import random
from mysql.connector import connect, Error

config = {
    'user': 'test',
    'password': 'test',
    'host': '192.168.1.13',
    'database': 'test',
    'raise_on_warnings': True,
    'auth_plugin': 'mysql_native_password'
}


database = []
uuid = []

class Database:

    def __init__(self):
        start = False
        try:
            mysql.connector.connect(**config)
            start = True
        except Exception as e:
            print("Error at:")
            print(e)
            print()
            print("Exiting...")
            exit()
        if start:
            self.db = connect(**config)

    def get_started(self):
        db = self.db.cursor()
        db.execute("SELECT * FROM owned_vehicles WHERE vin IS NULL")
        users = db.fetchall()
        for cars in users:
            database.append(cars[3])
        db.execute("SELECT * FROM company_vehicles WHERE vin IS NULL")
        company = db.fetchall()
        for company_cars in company:
            database.append(company_cars[2])

    def get_started_uuid(self):
        db = self.db.cursor()
        db.execute("SELECT * FROM owned_vehicles")
        users = db.fetchall()
        for cars in users:
            uuid.append(cars[3])
        db.execute("SELECT * FROM company_vehicles")
        company = db.fetchall()
        for company_cars in company:
            uuid.append(company_cars[2])

    def check_vin(self, vin):
        db = self.db.cursor()
        db.execute("SELECT * FROM owned_vehicles WHERE vin = %s", (vin,))
        cars = db.fetchall()
        if len(cars) == 0:
            db.execute("SELECT * FROM company_vehicles WHERE vin = %s", (vin,))
            company_cars = db.fetchall()
            if len(company_cars) == 0:
                return True
        return False

    def check_uuid(self, uuid):
        db = self.db.cursor()
        db.execute("SELECT * FROM owned_vehicles WHERE vin = %s", (uuid,))
        cars = db.fetchall()
        if len(cars) == 0:
            db.execute("SELECT * FROM company_vehicles WHERE vin = %s", (uuid,))
            company_cars = db.fetchall()
            if len(company_cars) == 0:
                return True
        return False

    def insert_vin(self, spz, vin):
        db = self.db.cursor()
        db.execute("UPDATE owned_vehicles SET vin = %s WHERE plate = %s", (vin, spz))
        db.execute("UPDATE company_vehicles SET vin = %s WHERE plate = %s", (vin, spz))
        self.db.commit()

    def insert_uuid(self, spz, uuid):
        db = self.db.cursor()
        db.execute("UPDATE owned_vehicles SET uuid = %s WHERE plate = %s", (uuid, spz))
        db.execute("UPDATE company_vehicles SET uuid = %s WHERE plate = %s", (uuid, spz))
        self.db.commit()


con = Database()
characters = []
numbers = []


for i in range(65, 91):
    characters.append(chr(i))

for i in range(48, 58):
    numbers.append(chr(i))


def character(length):
    msg = ""
    ll = []
    for y in range(0, length):
        ll.append(random.choice(characters))
    return msg.join(ll)


def number(length):
    msg = ""
    ll = []
    for y in range(0, length):
        ll.append(random.choice(numbers))
    return msg.join(ll)


def create_vin():
    vin_cr = f'{number(1)}{character(4)}{number(2)}{character(4)}{number(6)}'
    if con.check_vin(vin_cr):
        return vin_cr
    return create_vin()


def create_uuid():
    vin_cr = f'{number(4)}{number(5)}'
    if con.check_uuid(vin_cr):
        return vin_cr
    return create_uuid()


con.get_started()

for vehicles in database:
    vin = create_vin()
    print(vehicles, vin)
    con.insert_vin(vehicles, vin)

con.get_started_uuid()
for vehicles in uuid:
    uuid = create_uuid()
    print(vehicles, uuid)
    con.insert_uuid(vehicles, uuid)
