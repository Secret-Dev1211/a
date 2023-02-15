function check_github_status() {
    # >> Melakukan Ping ke github
    ping -q -c1 github.com &> /dev/null && status='1' || status='0'

    # >> Melakukan Validasi
    if [[ $status == '1' ]]; then
        STT="OKE GITHUB IS ONLINE";
    else
        echo "Woy Sabar ya kontol. Github lagi down !"; exit 1
    fi
}

function get_license_data() {
    # >> Menjalankan function pengecekan status github
    check_github_status

    # >> Mengecek apakah packages curl udh ke install belum
    if ! command -V curl > /dev/null 2>&1; then
        echo "Woy Kontol Curl tidak keinstall !"; exit 1
    fi

    # >> Mengecek apakah packages jq udh ke install belum
    if ! command -V jq > /dev/null 2>&1; then
        echo "Woy Kontol JQ tidak keinstall !"; exit 1
    fi

    # >> Get Client IP Address
    export inihanyaipclientsihgaadaapaapa=$( curl -s --ipv4 https://api.wildy.my.id/ipgeo/ | jq -r '.ip' )

    # >> Mengambil data dari github
    datacache=$(curl -s --ipv4 "https://raw.githubusercontent.com/Secret-Dev1211/a/main/client.json")
    baris=$(( $(echo $datacache | jq '.data[].ip' | sed 's/"//g' | grep -n -m 1 "$inihanyaipclientsihgaadaapaapa" | cut -f1 -d ":" | head -n1) - 1 ))

    # >> Malas bat mau ketik jadi ini comment ketik sendiri aja deh ya oawkoawkawokoaw
    export ambildatadarijsonnyatadi=$(echo $datacache | jq ".data[${baris}]" )
    export halo_ip=$(echo $ambildatadarijsonnyatadi | jq -r '.ip' )
    export halo_name=$(echo $ambildatadarijsonnyatadi | jq -r '.name' )
    export halo_created=$(echo $ambildatadarijsonnyatadi | jq -r '.created' )
    export halo_expired=$(echo $ambildatadarijsonnyatadi | jq -r '.expired' )
    export todayfromxnxx=$(date +"%Y-%m-%d" -d "$(curl --head -s --disable "https://xnxx.com" | grep Date | sed 's/Date: //g')")
    export tanggalserver_kakak=$(echo $todayfromxnxx)
    export tanggalexpired_kakak=$(echo $halo_expired)
    export sisaharinyakakak=$(( ($tanggalserver_kakak - $tanggalexpired_kakak) / 86400 ))
    export sisahariformatbiasa=$(date -d "$sisaharinyakakak days" +"%Y-%m-%d")

    if [[ $halo_expired == 'null' ]]; then
        echo "Terjadi kesalahan pada server !"; exit 1
    fi

    if [[ $sisaharinyakakak -lt 0 ]]; then
        echo "NAH INI DI SINI UDH KEDETEK EXPIRED JADI MAU APAKAH YA SUKA SUKA ELU MAH"
    fi
}


get_license_data # >> JALANKAN BUAT CEK
