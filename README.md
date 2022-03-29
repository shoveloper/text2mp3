# text2mp3.sh
입력받은 텍스트을 바탕으로 파파고 TTS를 연동해 음성파일을 생성합니다.

## Prequisites
 - openssl
 - curl

## Usage

입력 발화는 따옴표로 묶어야 합니다.

```
$ ./text2mp3.sh "안녕, 마일로?" hi.mp3
```
