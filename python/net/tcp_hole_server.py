import socket
import sys
import thread

HOST = ''
PORT = 8123                     # using env to get port when upload to cloud

#Function for handling connections. This will be used to create threads
def clientthread(conn):
    #Sending message to connected client
    conn.send('Welcome to the server. Type something and hit enter\n') #send only takes string

    #infinite loop so that function do not terminate and thread do not end.
    while True :
        #Receiving from client
        data = conn.recv(1024)
        if not data:
            break

        reply = 'OK...' + data
        conn.sendall(reply)

    #came out of loop
    conn.close()

def server_main():

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM) # TCP

    print "Socket created"
    try:
        s.bind((HOST, PORT))
    except socket.error, msg:
        print "Bind failed. Error code : " + str(msg[0]) + " Message " + msg[1]
        sys.exit()

    print "Socket bind complete"

    s.listen(10)                    # 10 , the size of waiting queue.

    print "Socket now listening"

    while True:
        conn, addr = s.accept()
        print "Connect with " + addr[0] + ":" + str(addr[1])

        thread.start_new_thread(clientthread ,(conn,))

    s.close()

if __name__ == '__main__':
    server_main()
