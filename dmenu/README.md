# My d`menu` configuration

- Author  : Harshit Prahant Dhanwalkar
- Github  : @Harshit-Dhanwalkar

Build from source
```bash
sudo make clean install
```

### Theme

To change them make changes in [config.h](./config.h)

### Patches
1. Fuzzy match

I have implemented my version of fuzzy match (being very premitive, it requires you to type exactly the first letters in order)
For e.g.: if you are searching for `Reddit`
 - Works for `red`,`rdd`,`redit`
 - ✖ Does NOT work for `rdt`, `r d t`
