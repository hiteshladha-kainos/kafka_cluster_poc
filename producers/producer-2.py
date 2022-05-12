import pika


def main():
    connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
    channel = connection.channel()

    payload = '{ "country": "US","customer_id": "37416437"}'
    for i in range(0, 10):
        channel.basic_publish(exchange='customers',
                              routing_key='us.customer.subscription.created',
                              body=payload)
    print(f"messages sent successfully")

    connection.close()


if __name__ == '__main__':
    main()
