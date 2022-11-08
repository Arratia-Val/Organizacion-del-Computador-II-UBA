/* ** por compatibilidad se omiten tildes **
================================================================================
 TRABAJO PRACTICO 3 - System Programming - ORGANIZACION DE COMPUTADOR II - FCEN
================================================================================

  Definicion de funciones del manejador de memoria
*/

#include "mmu.h"
#include "i386.h"

#include "kassert.h"

static pd_entry_t* kpd = (pd_entry_t*)KERNEL_PAGE_DIR;  //puntero a directorio comienza en 0x25000
static pt_entry_t* kpt = (pt_entry_t*)KERNEL_PAGE_TABLE_0; //puntero a tabla comienza en 0x26000

//static const uint32_t identity_mapping_end = 0x003FFFFF;
//static const uint32_t user_memory_pool_end = 0x02FFFFFF;

static paddr_t next_free_kernel_page = 0x100000;
static paddr_t next_free_user_page = 0x400000;


/**
 * kmemset asigna el valor c a un rango de memoria interpretado
 * como un rango de bytes de largo n que comienza en s
 * @param s es el puntero al comienzo del rango de memoria
 * @param c es el valor a asignar en cada byte de s[0..n-1]
 * @param n es el tamaño en bytes a asignar
 * @return devuelve el puntero al rango modificado (alias de s)
*/
static inline void* kmemset(void* s, int c, size_t n) {
  uint8_t* dst = (uint8_t*)s;
  for (size_t i = 0; i < n; i++) {
    dst[i] = c;
  }
  return dst;
}

/**
 * zero_page limpia el contenido de una página que comienza en addr
 * @param addr es la dirección del comienzo de la página a limpiar
*/
static inline void zero_page(paddr_t addr) {
  kmemset((void*)addr, 0x00, PAGE_SIZE);
}


void mmu_init(void) {

}


/**
 * mmu_next_free_kernel_page devuelve la dirección de la próxima página de kernel disponible
 * @return devuelve la dirección de memoria de comienzo de la próxima página libre de kernel
 */
paddr_t mmu_next_free_kernel_page(void) {
  next_free_kernel_page = next_free_kernel_page + PAGE_SIZE;
  return next_free_kernel_page-PAGE_SIZE;  
}

/**
 * mmu_next_free_user_page devuelve la dirección de la próxima página de usuarix disponible
 * @return devuelve la dirección de memoria de comienzo de la próxima página libre de usuarix
 */
paddr_t mmu_next_free_user_page(void) {
  next_free_user_page = next_free_user_page + PAGE_SIZE;
  return next_free_user_page-PAGE_SIZE;
}



/**
 * mmu_init_kernel_dir inicializa las estructuras de paginación vinculadas al kernel y
 * realiza el identity mapping
 * @return devuelve la dirección de memoria de la página donde se encuentra el directorio
 * de páginas usado por el kernel
 */
paddr_t mmu_init_kernel_dir(void) {
  //tengo que pedir memoria espacio para las tablas y directorio?
  //usar zero_page?pt_entry_t* kpt = (pt_entry_t*)KERNEL_PAGE_TABLE_0;

  kpd[0].pt=(KERNEL_PAGE_TABLE_0 >> 12); //kpd[0].pt tiene que apuntar a la primera tabla que comienza en 0x26000
  //pt agarra los mas significativos es decir el 0x26 sin los 000 pues esos son para la pagina
  kpd[0].pt = 0x26;
  kpd[0].attrs=0x3;

  for(int i=0;i<1024;i++){
    kpt[i].page= i;//numero de pagina
    kpt[i].attrs=0x3;
  }
  return KERNEL_PAGE_DIR;
}


/**
 * mmu_map_page agrega las entradas necesarias a las estructuras de paginación de modo de que
 * la dirección virtual virt se traduzca en la dirección física phy con los atributos definidos en attrs
 * @param cr3 el contenido que se ha de cargar en un registro CR3 al realizar la traducción
 * @param virt la dirección virtual que se ha de traducir en phy
 * @param phy la dirección física que debe ser accedida (dirección de destino)
 * @param attrs los atributos a asignar en la entrada de la tabla de páginas
 */
void mmu_map_page(uint32_t cr3, vaddr_t virt, paddr_t phy, uint32_t attrs) {
  pd_entry_t* directory = (pd_entry_t*)CR3_TO_PAGE_DIR(cr3);
  //VIRT_PAGE_TABLE(virt) = devuelve una entrada de 32 bits 
  
  if(directory[VIRT_PAGE_DIR(virt)].attrs ==0x0){   //Chequea si existe esa tabla de paginas definida en esa pos del directorio
    paddr_t dir = mmu_next_free_kernel_page();      //Pedimos una posición libre en el Kernel para la tabla de página (a partir de 0x26)
    						    // CREAMOS la TABLA de pagina en el directorio
    directory[VIRT_PAGE_DIR(virt)].pt = (dir>>12);  //La dir de la tabla de paginas es en 0x26(el inicio ya que los otros 000 son 
    						    //los 4kb ocupados por la *TABLA* de página)
  }
  
  directory[VIRT_PAGE_DIR(virt)].attrs = attrs;	    //le asigna los atributos a la TABLA de página
  pt_entry_t* tabla =  (pt_entry_t*) (directory[VIRT_PAGE_DIR(virt)].pt << 12);   //creo puntero a tabla con la dirección indicada
  										  //en el directorio(en la pos donde ya creamos la tabla)
  										  //y lo shifteamos 12 para que reciba el pt_entry_t
  										  //de 32 bits
  										  
  paddr_t pt_index = (VIRT_PAGE_TABLE(virt)); 
  tabla[pt_index].page  = (phy>>12);		//PHY es una DIR en la pagina es decir que es de la forma 0x26480 o 0x26566
  						//es decir, se usan los ultimos 3 dig 000 para la dir del contenido de la PÁGINA
  						//Por lo tanto donde comienza la página es en 0x26 o el numero que indice PHY 
  						//por eso se shiftea 12
  						//La direccion de la pagina era la q teniamos que mapear con PHY
  		//EL offset idk deberia ser el mismoo de la dir virtual/lineal y PHY 	
  tabla[pt_index].attrs=attrs;			//atributos de la página
}
/**
 * mmu_unmap_page elimina la entrada vinculada a la dirección virt en la tabla de páginas correspondiente
 * @param virt la dirección virtual que se ha de desvincular
 * @return la dirección física de la página desvinculada
*/ 
paddr_t mmu_unmap_page(uint32_t cr3, vaddr_t virt) {
  pd_entry_t* directory = (pd_entry_t*)CR3_TO_PAGE_DIR(cr3);

  pt_entry_t* tablas =  (pt_entry_t*) (directory[VIRT_PAGE_DIR(virt)].pt << 12);
  paddr_t pt_index = (VIRT_PAGE_TABLE(virt)); 
  tablas[pt_index].attrs = 0x02;
  breakpoint();
  /*pt_entry_t* pt_index = (pt_entry_t*)((directory[VIRT_PAGE_DIR(virt)].pt ) | VIRT_PAGE_TABLE(virt)) ;
  pt_index->page = 0x0 ;
  pt_index->attrs=0x0;
  */
  return tablas->page;
}

#define DST_VIRT_PAGE 0xA00000
#define SRC_VIRT_PAGE 0xB00000

/**
 * copy_page copia el contenido de la página física localizada en la dirección src_addr a la página física ubicada en dst_addr
 * @param dst_addr la dirección a cuya página queremos copiar el contenido
 * @param src_addr la dirección de la página cuyo contenido queremos copiar
 *
 * Esta función mapea ambas páginas a las direcciones SRC_VIRT_PAGE y DST_VIRT_PAGE, respectivamente, realiza
 * la copia y luego desmapea las páginas. Usar la función rcr3 definida en i386.h para obtener el cr3 actual
 */
static inline void copy_page(paddr_t dst_addr, paddr_t src_addr) {
// mmu_map_page
breakpoint();
  paddr_t * destino = (paddr_t *) dst_addr;
  paddr_t * fuente = (paddr_t * ) src_addr;
  for (size_t i = 0; i < 4093; i++)
  {
    *(destino + i) = *(fuente + i);
  }
  //desmapear src
  
}

 /**
 * mmu_init_task_dir inicializa las estructuras de paginación vinculadas a una tarea cuyo código se encuentra en la dirección phy_start
 * @pararm phy_start es la dirección donde comienzan las dos páginas de código de la tarea asociada a esta llamada
 * @return el contenido que se ha de cargar en un registro CR3 para la tarea asociada a esta llamada
 * 
paddr_t mmu_init_task_dir(paddr_t phy_start) {

}

*/

