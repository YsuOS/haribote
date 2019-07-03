#define COL8_000000    0
#define COL8_FF0000    1
#define COL8_00FF00    2
#define COL8_FFFF00    3
#define COL8_0000FF    4
#define COL8_FF00FF    5
#define COL8_00FFFF    6
#define COL8_FFFFFF    7
#define COL8_C6C6C6    8
#define COL8_840000    9
#define COL8_008400    10
#define COL8_848400    11
#define COL8_000084    12
#define COL8_840084    13
#define COL8_008484    14
#define COL8_848484    15
//今回は8bit color なので，8bit (00000000-ffffffff)つまり16種類しか色が使えない

void io_hlt(void);
void io_cli(void);
void io_out8(int port, int data);
int io_load_eflags(void);
void io_store_eflags(int eflags);

void init_palette(void);
void set_palette(int start, int end, unsigned char *rgb);
void boxfill8(unsigned char *vram, int xsize, unsigned char c,
        int x0, int y0, int x1, int y1);
void init_screen(char *vram, int x, int y);
void putfont8(char *vram, int xsize, int x, int y, char c, char *font);
void putfonts8_asc(char *vram, int xsize, int x, int y, char c, unsigned char *s);
extern void sprintf(char *str, char *fmt, ...);
void init_mouse_cursor8(char *mouse, char bc);
void putblock8_8(char *vram, int vxsize, int pxsize, int pysize,
        int px0, int py0, char *buf, int bxsize);
        // vxsize : 画面の横幅
        // pxsize : picture x size
        // pysize : picture y size
        // px0 : cursor x
        // py0 : cursor y

struct BootInfo {
    char cyls, leds, vmode, reserve;
    short scrnx, scrny;
    char *vram;
};

struct SegmentDescriptor {
    short limit_low, base_low;
    char base_mid, access_right;
    char limit_high, base_high;
};

struct GateDescriptor {
    short offset_low, selector;
    char dw_count, access_right;
    short offset_high;
};

void set_segmdesc(struct SegmentDescriptor * sd, unsigned int limit, int base, int ar);
void set_gatedesc(struct GateDescriptor * gd, int offset, int selector, int ar);
void init_gdtidt(void);
void load_gdtr(int limit, int addr);
void load_idtr(int limit, int addr);

void HariMain(void)
{
    struct BootInfo *binfo = (struct BootInfo *) 0x0ff0;
    extern char hankaku[4096];
    char s[40], mcursor[256];
    int mx, my;

    init_gdtidt();
    init_palette();
    init_screen(binfo->vram, binfo->scrnx, binfo->scrny);

    putfonts8_asc(binfo->vram, binfo->scrnx, 8, 8, COL8_FFFFFF, "ABC 123");
    putfonts8_asc(binfo->vram, binfo->scrnx, 31, 31, COL8_000000, "Haribote OS.");
    putfonts8_asc(binfo->vram, binfo->scrnx, 30, 30, COL8_FFFFFF, "Haribote OS.");

    mx = (binfo->scrnx - 16) / 2;
    my = (binfo->scrny - 28 - 16) / 2;

    init_mouse_cursor8(mcursor, COL8_008484);
    putblock8_8(binfo->vram, binfo->scrnx, 16, 16, mx, my, mcursor, 16);

    sprintf(s, "scrnx = %d", binfo->scrnx);
    putfonts8_asc(binfo->vram, binfo->scrnx, 16, 64, COL8_FFFFFF, s);

    for(;;) {
        io_hlt();
    }
}

