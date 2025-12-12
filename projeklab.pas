program Hotell;
uses crt;

const { Menyimpan batas lantai dan kamar }
    LantaiMax = 3;
    KamarMax  = 10;

type 
    DataTamu = record {Record untuk menyimpan data tamu hotel}
    nama : string;
    nik : string;
    noHp : string;
    tanggalCheckIn : string;
    tanggalCheckOut : string;
    end;
    TArrayInt = array[1..LantaiMax, 1..KamarMax] of integer;

var
    hotelPilihan: integer;
    hotel: TArrayInt;
    booked: TArrayInt;
    pilihan: char;
    jumlahMalam : integer;
    data: DataTamu;

procedure pilihHotel(); { Prosedur untuk input data tamu dan memilih hotel }
begin
    clrscr;
    writeln('Selamat datang di program pemesanan hotel Medan!');
    with data do 
    begin 
    write('Nama anda            : '); readln(nama);
    write('NIK                  : '); readln(nik);
    write('No Telepon           : '); readln(noHp);
    write('Tanggal check in     : '); readln(tanggalCheckIn);
    write('Tanggal check out    : '); readln(tanggalCheckOut);
    end;

    writeln;
    writeln('Halo ', data.nama, '! Berikut hotel yang ada di Medan:');
    writeln('1. Hotel Santika       (Rp 500.000/malam)');
    writeln('2. Hotel Adimulia      (Rp 750.000/malam)');
    writeln('3. Hotel Grand Antares (Rp 1.000.000/malam)');
    writeln('4. Hotel Grand Mercure (Rp 1.500.000/malam)');
    writeln('5. Hotel JW Marriot    (Rp 2.000.000/malam)');

    repeat
        write('Pilih hotel (1-5): ');
        readln(hotelPilihan);
        if (hotelPilihan < 1) or (hotelPilihan > 5) then
            writeln('Input salah! Pilih 1 sampai 5.');
    until (hotelPilihan >= 1) and (hotelPilihan <= 5);

    writeln;

    case hotelPilihan of
        1 : writeln('Anda memilih Hotel Santika (Rp 500.000/malam)');
        2 : writeln('Anda memilih Hotel Adimulia (Rp 750.000/malam)');
        3 : writeln('Anda memilih Hotel Grand Antares (Rp 1.000.000/malam)');
        4 : writeln('Anda memilih Hotel Grand Mercure (Rp 1.500.000/malam)');
        5 : writeln('Anda memilih JW Marriot (Rp 2.000.000/malam)');
    end;

    writeln;
    repeat
        write('Menginap berapa malam? ');
        readln(jumlahMalam);
        if jumlahMalam <= 0 then
            writeln('Jumlah malam harus lebih dari 0!');
    until jumlahMalam > 0;
    writeln;
    end;

procedure generateKamar(var h : TArrayInt; var b : TArrayInt); { Mengisi status kamar secara acak dan mereset booked }
var 
    i, j : integer;
begin 
    Randomize;
    for i := 1 to LantaiMax do
        for j := 1 to KamarMax do
        begin
            h[i][j] := Random(2);
            b[i][j] := 0;
        end;
end;

procedure tampilkanLantai(h : TArrayInt; lantai : integer); { Menampilkan status kamar per lantai }
var
    j : integer;
begin 

    writeln('0 = TERISI (MERAH), 1 = KOSONG (HIJAU)');
    writeln('Kamar pada lantai ', lantai, ':');

    for j := 1 to KamarMax do
    begin
        write('[', j:2, ': ');
        if h[lantai][j] = 1 then
        begin
            textcolor(Green);
            write('1');
        end
        else
        begin
            textcolor(LightRed);
            write('0');
        end;
        textcolor(White);
        write('] ');
    end;

    writeln;
end;

procedure pesanKamar(var h : TArrayInt; var b : TArrayInt); { Prosedur pemesanan kamar oleh tamu }
var
    lantai, kamar, lagi : integer;
begin 
    repeat
        writeln;
        repeat
            write('Pilih lantai (1-', LantaiMax, '): ');
            readln(lantai);
        until (lantai >= 1) and (lantai <= LantaiMax);

        clrscr;
        tampilkanLantai(h, lantai);

        writeln;
        repeat { Menyimpan status kamar dan kamar yang dipesan }
            write('Pilih nomor kamar (1-', KamarMax, '): ');
            readln(kamar);
        until (kamar >= 1) and (kamar <= KamarMax);

        if h[lantai][kamar] = 0 then
        begin
            textcolor(LightRed);
            writeln('Kamar SUDAH terisi!');
        end
        else
        begin
            b[lantai][kamar] := 1;
            h[lantai][kamar] := 0;
            textcolor(Green);
            writeln('Kamar BERHASIL dipesan!');
        end;

        textcolor(White);
        writeln;
        write('Pesan kamar lain? (1 = ya, 0 = tidak): ');
        readln(lagi);
        clrscr;

    until lagi = 0;
end;

function hitungBiaya(b : TArrayInt; hotelPilihan : integer) : LongInt; { Menghitung total biaya berdasarkan kamar yang dipesan }
var
    i, j : integer;
    harga : LongInt;
begin 
    case hotelPilihan of
        1 : harga := 500000;
        2 : harga := 750000;
        3 : harga := 1000000;
        4 : harga := 1500000;
        5 : harga := 2000000;
    else
        harga := 0;
    end;

    hitungBiaya := 0;

    for i := 1 to LantaiMax do
        for j := 1 to KamarMax do
            if b[i][j] = 1 then
                hitungBiaya := hitungBiaya + (harga * jumlahMalam);
end;

procedure resetSemuaData(); { Mereset semua data tamu dan data pemesanan }

var i,j: integer;
begin
    data.nama := '';
    data.nik := '';
    data.noHp := '';
    data.tanggalCheckIn := '';
    data.tanggalCheckOut := '';
    hotelPilihan := 0;

    for i := 1 to LantaiMax do
        for j := 1 to KamarMax do
            booked[i][j] := 0;
end;

procedure cetakStruk(b : TArrayInt; hotelPilihan : integer); { Menampilkan struk pemesanan }

var
    i, j, count : integer;
    namaHotel : string;
begin 
    case hotelPilihan of
        1 : namaHotel := 'Hotel Santika';
        2 : namaHotel := 'Hotel Adimulia';
        3 : namaHotel := 'Hotel Grand Antares';
        4 : namaHotel := 'Hotel Grand Mercure';
        5 : namaHotel := 'Hotel JW Marriot';
    else
        namaHotel := 'Tidak Diketahui';
    end;

    clrscr;
    writeln('======================================');
    writeln('                STRUK');
    writeln('======================================');
    writeln('Nama Pemesan : ', data.nama);
    writeln('Hotel Dipilih: ', namaHotel);
    writeln('--------------------------------------');
    writeln('Kamar yang dipesan:');

    count := 0;
    for i := 1 to LantaiMax do
        for j := 1 to KamarMax do
            if b[i][j] = 1 then
            begin
                writeln('- Lantai ', i, ' | Kamar ', j);
                count := count + 1;
            end;

    if count = 0 then
        writeln('(Belum ada kamar yang dipesan)');

    writeln('--------------------------------------');
    writeln('Total kamar  : ', count);
    writeln('Jumlah malam : ', jumlahMalam);
    writeln('Total biaya  : Rp ', hitungBiaya(b, hotelPilihan));
    writeln('======================================');
    writeln('Terima kasih telah memesan!');
end;


begin { Bagian utama program }
    pilihHotel();
    generateKamar(hotel, booked);
    pesanKamar(hotel, booked);

    repeat
        clrscr;
        writeln('Total biaya sementara: Rp ', hitungBiaya(booked, hotelPilihan));
        writeln;
        writeln('Apa yang ingin anda lakukan sekarang? ');
        writeln('A. Lanjutkan memesan kamar');
        writeln('B. Log out & pilih hotel lagi (RESET DATA)');
        writeln('C. Cetak struk pemesanan');
        write('Pilihan Anda (A-C): ');
        readln(pilihan);

        case pilihan of
        'A','a' :
            begin
                clrscr;
                pesanKamar(hotel, booked);
            end;

        'B','b' :
            begin
                resetSemuaData();
                clrscr;
                pilihHotel();
                generateKamar(hotel, booked);
                pesanKamar(hotel, booked);
            end;

        'C','c' :
        begin
            cetakStruk(booked, hotelPilihan);
            writeln;
            writeln('Tekan ENTER untuk keluar...');
            readln;
            exit;
        end;

        else
            writeln('Pilihan tidak valid! Tekan ENTER untuk lanjut...');
            readln;
        end;

    until pilihan in ['C','c'];

end.