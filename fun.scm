(require-extension bind)

(bind* #<<EOF
    int addz(int a, int b) {
        return a + b;
    }

    int removez(int a, int b) {
        return a - b;
    }
EOF
)

(print (addz 1 2))
(print (addz (removez "a" "b") 2))
