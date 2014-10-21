sudo mount -t nfs -o soft,intr,rsize=8192,wsize=8192,timeo=900,retrans=3,proto=tcp,rw 192.168.33.12:/export ../export
