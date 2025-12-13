$TTL	1w
@	IN	SOA	ns1.example.com. admin.replset.com. (
			2025 		; Serial
			1w		; Refresh
			1d		; Retry
			28d		; Expire
			1w) 	; Negative Cache TTL
			 
; name servers - NS records
		IN	NS	ns1.example.com.

; name servers - A records
ns1.example.com.		IN	A	10.0.2.5

; 10.0.2.0/24 - A records
mongod0 IN      A       10.0.2.151       
mongod1 IN      A       10.0.2.152      
mongod2 IN      A       10.0.2.153
