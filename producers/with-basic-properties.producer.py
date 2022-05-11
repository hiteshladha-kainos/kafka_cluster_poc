import pika
import json

def main():
    connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
    channel = connection.channel()

    properties = pika.BasicProperties(content_type='application/json', delivery_mode=1, priority=1, content_encoding='utf-8')

    payload = '{ "type": "customer.subscription.created", "producer": "intfood", "payload": { "country": "US", "customer_id": "37416437", "customer_uuid": "67feebee-8120-4966-8203-43ca39e3db38", "email": "test@outlook.com", "subscription": { "id": "16934765", "product_sku": "US-CBT8-4-2-0", "product_family": "classic-box-t8", "unit_price": "71.92", "canceled_at": null, "delivery_time": "US-7-0800-2000", "delivery_interval": "1", "delivery_start": "2021-11-07", "voucher_code": null, "customer_id": "37416437", "paused_at": null, "preset": "fit", "established_at": "2021-11-02T02:54:18-07:00", "id_sales_order_item": "163317310", "billing_address": { "id": "53044029", "first_name": "Test", "last_name": "Test", "phone": "1111111111", "cell_phone": null, "address1": "test St 1", "address1_no": null, "address1_street": null, "address2": null, "address2_comment": null, "address2_comment2": null, "postcode": "10000", "city": "New York", "city_code": null, "neighborhood": null, "other_delivery_instructions": null }, "shipping_address": { "id": "53044030", "first_name": "test", "last_name": "test", "phone": "1111111111", "cell_phone": null, "address1": "Test St 1", "address1_no": null, "address1_street": null, "address2": null, "address2_comment": null, "address2_comment2": null, "postcode": "10000", "city": "New York", "city_code": null, "neighborhood": null, "other_delivery_instructions": null } }, "order_nr": "2773738959", "order_coupon_code": null }, "timestamp": "2021-11-02T09:54:20.288482Z", "timestamp_string": "2021-11-02T02:54:20.000000-0700", "event_uuid": "403881ba-daad-431d-8af1-e615e5476880" }'


    for i in range(0, 10):
        properties.message_id = str(i)
        channel.basic_publish(exchange='customers',
                              routing_key='us.customer.subscription.created',
                              body=payload,
                              properties = properties)
    print(f"messages sent successfully")

    connection.close()


if __name__ == '__main__':
    main()
