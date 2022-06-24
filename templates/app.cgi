#!/usr/bin/python3
from wsgiref.handlers import CGIHandler
from flask import Flask
from flask import render_template, request
import psycopg2
import psycopg2.extras

## SGBD configs
DB_HOST = "db.tecnico.ulisboa.pt"
DB_USER = "ist196870"
DB_DATABASE = DB_USER
DB_PASSWORD = "owbc6090"
DB_CONNECTION_STRING = "host=%s dbname=%s user=%s password=%s" % (
    DB_HOST,
    DB_DATABASE,
    DB_USER,
    DB_PASSWORD,
)

app = Flask(__name__)


@app.route("/")
def main_menu():
    try:

        return render_template("index.html")
    except Exception as e:
        return str(e)  # Renders a page with the error.
    

@app.route("/accounts")
def list_accounts_edit():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM super_categoria;"
        cursor.execute(query)
        return render_template("accounts.html", cursor=cursor, params=request.args)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route("/retalhistas")
def retalhistas():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM retalhista;"
        cursor.execute(query)
        return render_template("retalhistas.html", cursor=cursor, params=request.args)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

app.route("/listarEventos")
def listarIVM():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM IVM;"
        cursor.execute(query)
        return render_template("listarEventos.html", cursor=cursor, params=request.args)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route("/listarCat>")
def listSubCats(superCat = None):
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM super_categoria;"
        cursor.execute(query)
        return render_template("listarCat.html", cursor=cursor)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route("/removeCat/<nome_cat>", methods=["GET"])
def remove_cat(nome_cat = None):
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        query = "DELETE FROM super_categoria WHERE (nome =" + "'" + nome_cat + "');"

        cursor.execute(query)
        return query
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()


@app.route("/removeRetalhista/<tin>", methods=["GET"])
def remove_ret(tin = None):
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        query = "DELETE FROM retalhista WHERE (tin =" + "'" + tin + "');"

        cursor.execute(query)
        return query
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route("/listIVM/<IVM>", methods=["GET"])
def listRepOfIvm(IVM = None):
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)

        query = "SELECT * FROM ivm NATURAL JOIN evento_reposicao WHERE (num_serie = '{int(IVM)}');"
        cursor.execute(query)
        return render_template("listRepOfIvm.html", cursor = cursor, IVM = IVM)
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

CGIHandler().run(app)
