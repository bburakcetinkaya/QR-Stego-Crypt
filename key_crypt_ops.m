function Keys = key_crypt_ops(keys,MASTERKEY)

KEY1 = keys.KEY1;
KEY2 = keys.KEY2;
KEY3 = keys.KEY3;

Keys.KEY1 = bitxor(MASTERKEY,KEY1);
Keys.KEY2 = bitxor(MASTERKEY,KEY2);
Keys.KEY3 = bitxor(MASTERKEY,KEY3);




