import pika, sys, os, json


def main():
    def callback(ch, method, properties, body):
        print(body)
        ch.basic_ack(delivery_tag=method.delivery_tag)

    connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
    channel = connection.channel()

    channel.basic_consume(queue='us.customer.subscription.created',
                          auto_ack=False,
                          on_message_callback=callback)

    print(' [*] Waiting for messages')
    channel.start_consuming()


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('Interrupted')
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)
