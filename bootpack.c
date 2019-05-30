# define COL8_000000    0
# define COL8_FF0000    1
# define COL8_00FF00    2
# define COL8_FFFF00    3
# define COL8_0000FF    4
# define COL8_FF00FF    5
# define COL8_00FFFF    6
# define COL8_FFFFFF    7
# define COL8_C6C6C6    8
# define COL8_840000    9
# define COL8_008400    10
# define COL8_848400    11
# define COL8_000084    12
# define COL8_840084    13
# define COL8_008484    14
# define COL8_848484    15
void _io_hlt(void);
void _write_mem8(int addr, int data);

void HariMain(void)
{
    char *p;

    init_palette();

    p = (char *) 0xa0000;

    boxfill8(p, 320, COL8_FF0000, 20, 20, 120, 120);
    boxfill8(p, 320, COL8_00FF00, 20, 20, 120, 120);
    boxfill8(p, 320, COL8_0000FF, 20, 20, 120, 120);

    for(;;) {
        _io_hlt();
    }
}

void boxfill8(unsigned char *vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1)
{
    int x, y;
    for (y = y0; y <= y1; y++) {
        for (x = x0; x <= x1; x++)
            vram[y * xsize + x] = c;
    }
    return;
}
