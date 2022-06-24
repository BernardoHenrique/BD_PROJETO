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

@app.route("/listIVM")
def listIVM():
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM ivm;"
        cursor.execute(query)
        return render_template("listarIVM.html", cursor = cursor)
    except Exception as e:
        return str(e)
    finally:
        dbConn.commit()
        cursor.close()
        dbConn.close()

@app.route("/listarCat")
def listSubCats(superCat = None):
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM super_categoria;"
        cursor.execute(query)
        return render_template("listarCat.html", cursor=cursor, params=request.args)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route("/addCat")
def createCatPage():
    try:
        return render_template("addCategoria.html")
    except Exception as e:
        return str(e)

@app.route("/addRetalhista")
def createRetPage():
    try:
        return render_template("addRetalhista.html")
    except Exception as e:
        return str(e)

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

@app.route("/listSubCat/<superCategoria>")
def listSubCat(superCategoria = None):
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        #query = "SELECT categoria FROM tem_outra WHERE (super_categoria =" + "'" + superCategoria + "');"
        query = "WITH RECURSIVE subCategoria AS (\
        SELECT super_categoria, categoria FROM tem_outra\
        WHERE super_categoria = " + "'" + superCategoria + "'\
        UNION SELECT tem_outra.categoria, tem_outra.super_categoria\
            FROM tem_outra\
            INNER JOIN subCategoria ON subCategoria.categoria = tem_outra.super_categoria\
        ) SELECT categoria FROM subCategoria;"
        cursor.execute(query)
        return render_template("listSubCat.html", cursor = cursor, superCategoria = superCategoria)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

@app.route("/listarEventos/<ivm>")
def listarEventos(ivm = None):
    dbConn = None
    cursor = None
    try:
        dbConn = psycopg2.connect(DB_CONNECTION_STRING)
        cursor = dbConn.cursor(cursor_factory=psycopg2.extras.DictCursor)
        query = "SELECT * FROM evento_reposicao NATURAL JOIN tem_categoria WHERE (num_serie =" + "'" + ivm + "');"
        cursor.execute(query)
        return render_template("listarEventosIVM.html", cursor=cursor, ivm = ivm)
    except Exception as e:
        return str(e)
    finally:
        cursor.close()
        dbConn.close()

CGIHandler().run(app)
