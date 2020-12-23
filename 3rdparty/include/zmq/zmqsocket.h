#pragma once

class zmqsocket;

struct zmqsocket_handlemsg {
    virtual void on_sender_connected(zmqsocket_handlemsg* skt, zmqsocket* zmqskt) = 0;

    virtual void on_receiver_connected(zmqsocket_handlemsg* skt, zmqsocket* zmqskt) = 0;

    virtual void on_disconnected(zmqsocket_handlemsg* skt, zmqsocket* zmqskt, bool is_sender) = 0;

    virtual void on_message(zmqsocket_handlemsg* skt, zmqsocket* zmqskt, void* message, int len) = 0;

 protected:
  virtual ~zmqsocket_handlemsg() {}
};

class zmqsocket
{
public:
    zmqsocket() {};

    virtual ~zmqsocket() {};

    virtual void registerHandleMsg(zmqsocket_handlemsg* callback) = 0;

    virtual int sendmsg(void* msg, int len) = 0;

    virtual int wait_connected(int timeout_ms = 0) = 0;

    virtual const char* get_sender() = 0;

    virtual const char* get_receiver() = 0;

    virtual int testconnect(unsigned int timeout_ms) = 0;

	static zmqsocket* create(const char* sender, const char* receiver, const char* monitor);
};