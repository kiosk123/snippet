#!/bin/bash

#----------------------------------------------------------
# 첫번째 쉘 명령 결과에서 5번째 열의 데이터를 내림차순으로 정렬
$ ls -l /var/log | sort -rk 5

#----------------------------------------------------------
# 특정 시간에 명령이 실행되도록 예약
# at [옵션] [시간 2:10pm 또는 2:10am도 가능] [날짜 today] [+증가시간]
# /etc/at.allow /etc/at.deny에 사용자 등록을 통해 at 명령 권한여부 설정 가능
$ sudo at 23:26 2020-12-24
warning: commands will be executed using /bin/sh
at> echo "This time is"
at> date
at> <EOT> # ctrl + d
job 1 at Thu Dec 24 23:26:00 2020

# at 명령어로 설정된 예약된 작업 확인
$ sudo at -l
# 작업번호  실행날짜         실행시간      queue이름 예약사용자
2       Thu Dec 24 23:30:00 2020 a root

#----------------------------------------------------------
# chmod 파일 권한 설정
$ chmod 744 file
$ chmod rwx+ugo file

# SetUID 권한이 설정된 파일을 실행시 파일 실행시 파일의 소유주 권한으로 실행하도록 설정 
$ chmod 4755 file 
-rwsr-xr-x.  1 user user    0 12월 24 23:35 file # 소유주 권한 x가 s로 변경됨

# SetGID 권한이 설정된 파일을 실행할 때 파일의 그룹 권한으로 실행
$ chmod 2755 file 
-rwxr-sr-x.  1 user user    0 12월 24 23:35 file # 그룹 권한 x가 s로 변경됨

# StickyBit 권한이 설정된 파일의 삭제는 파일을 생성한 사용자 또는 root만 가능
# 다른 사람이 파일을 실행 및 수정은 할 수 있어서 삭제는 파일 생성자와 root만 가능
$ chmod 1755 file
-rwxr-xr-t. 1 user user 0 12월 24 23:35 file # 기타 사용자 권한의 x가 t로 변경됨

# SetUID(4) + StickyBit(1) 권한 설정
$ chmod 5755 file

#----------------------------------------------------------
# chown 파일 소유자 밋 소유 그룹 변경
# chown [옵션] [소유자].[그룹]
$ sudo chown root.root file

#----------------------------------------------------------
# cmp 파일을 비교하여 서로 다른 부분을 알려준다
$ cmp test1 test2
test1 test2 differ: byte 1, line 1

#----------------------------------------------------------
# col 개행(특수)문자와 공백등을 변환하는 필터 역할을 한다 \n\r문자를 \n변환하거나
# 공백문자를 탭 문자로 변환할 때 활용한다
# col [옵션]
$ cat test1 | col > test1 # col을 이용하여 test1의 파일의 내용을 치환한다
 
#----------------------------------------------------------
# colcrt 밑줄(_)을 감추거나 변환한다.
# 옵션 
# - :밑줄 속성이 있는 문자열을 표시하지 않는다.
# -2:밑줄 속성이 있는 문자열 다음줄에 하이픈을 포함하여 표시한다.
$ cat test
Linux_UNIX_Shell Script

$ colcrt test
Linux UNIX Shell Script
     -    -
	 
$ colcrt - test
Linux UNIX Shell Script

$ colcrt -2 test
Linux UNIX Shell Script
     -    -

#----------------------------------------------------------
# cut 텍스트 파일이나 파이프된 결과 중에서 지정된 부분만 표시
# 별도의 구분자 없이 사용했을 경우네는 바이트 단위로 구분 별도의 구분자를 지정시 지정한 구분자를 기준으로 구분자
# -b, -c, -f 옵션뒤에는 숫자범위 지정가능
# A : A번째, A-: A번째부터, A-B: A부터 B까지, -B: B까지
$ cat /etc/passwd | head -n 2
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin

# ":"를 구분자로 하여 1번과 7번 필드를 표시
$ cut -d ":" -f1,7 /etc/passwd | head -n 2
root:/bin/bash
bin:/sbin/nologin

# ":"를 구분자로 하여 3번부터 5번까지 필드를 표시
$ cut -d":" -f3-5 /etc/passwd | head -n 2
0:0:root
1:1:bin

#----------------------------------------------------------
# domainame 운영체제에 설정된 도메인 정보를 확인
# domainame [옵션] [도메인명]
$ domainname # 도메인 정보 출력
(none)
$ domainname -s # 간단한 호스트명 출력
localhost
$ domainname -f # 전체 호스트명 출력
localhost
$ domainname -d # dns 도메인명 출력
$ domainname -i # 호스트 IP주소 출력
::1 127.0.0.1








