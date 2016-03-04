import socket              
import time
import thread
import pickle

usuarios = []
usuario = {'id':1,'username':'bot1','posx':100.00,'posy':100.00}
usuarios.append(usuario)
usuario = {'id':2,'username':'bot2','posx':120.00,'posy':120.00}
usuarios.append(usuario)

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(('127.0.0.1', 3000))
s.listen(5)                

def session(conn, addr):
    while True:
        print 'Conn:', addr
        #conn.send('Please wait...')
        time.sleep(2)
        #conn.send('Thank you for connecting with your admin. Please write now.')

        while True:
            msg = conn.recv(1024)
            if not msg:
                conn.close()
                break
            elif msg == "close1234567890":
                print ("Connection with %s was closed by the client." % (addr[0]))
            else:
                print "%s: %s" % (addr[0], msg)

            for usuario in usuarios:
                conn.send(str(usuario))

while True:
    conn, addr = s.accept()
    thread.start_new_thread(session(conn, addr))

s.close()
