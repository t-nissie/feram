/* I/O UNIT NUMBERS */
#define UNIT_INPUT 7
#define UNIT_SYSTEM 8
#define UNIT_AVG 10
#define UNIT_HL 12
#define UNIT_DEFECTS_U 14
#define UNIT_T_LAYER 16
#define UNIT_LOG 18
#define UNIT_WISDOM 20
#define UNIT_QUADRATIC 22
#define UNIT_RELAXOR 24
#define UNIT_POLARIZATION 25
#define UNIT_MODULATION 26

/* length */
#define FILE_NAME_LEN 300
#define RELAXOR_MAX 3

/* mathematical and physical constants */
/* PI */
#define M_PI           3.14159265358979323846d0  /* pi */
#define M_2PI          6.28318530717958647693d0  /* 2*pi */
#define M_PI_2         1.57079632679489661923d0  /* pi/2 */
#define M_PI_4         0.78539816339744830962d0  /* pi/4 */
#define M_1_PI         0.31830988618379067154d0  /* 1/pi */
#define M_2_PI         0.63661977236758134308d0  /* 2/pi */
#define M_2_SQRTPI     1.12837916709551257390d0  /* 2/sqrt(pi) */

/* E_h = 27.211 383 86 eV   http://physics.nist.gov/cgi-bin/cuu/Value?hrev */
#define HARTREE_IN_EV  27.21138386d0
#define BOHR_RADIUS     0.5291772083d0 /* [Amgstrom] */
#define HARTREE_BOHR   14.399644d0 /* = e_Hartree [eV] * r_Bohr [Angstrom] = 27.21138386 * 0.5291772083 [eV Amgstrom] */
#define HARTREE_BOHR2  97.1736 /* = e_Hartree [eV] / r_Bohr^2 [Angstrom^2] = 27.21138386 / 0.5291772083**2 */
#define KELVIN_EV      11604.45d0  /* [K] */
#define ELEMENTARY_CHARGE 1.60217653d0 /* x 10^-19 C */
