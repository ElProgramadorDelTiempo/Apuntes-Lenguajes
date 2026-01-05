Apuntes Completo de TypeScript
Inferencia de tipo en TypeScript
typescript
let x: number;           // Declaración explícita
let y = 1;               // Inferencia de tipo como número
let z;                   // Tipo 'any' por defecto
Tipos primitivos en TypeScript
Tipo booleano
typescript
let flag: boolean;
let yes = true;          // Inferido como boolean
let no = false;          // Inferido como boolean
Tipos numéricos y BigInteger
typescript
let x: number;
let y = 0;               // Inferido como número
let z: number = 123.456; // Declaración explícita
let big: bigint = 100n;  // 'bigint' para enteros de precisión arbitraria
Tipo de cadena
typescript
let s: string;
let empty = "";          // Inferido como cadena vacía
let abc = 'abc';         // Inferido como cadena

// Template literals
let firstName: string = "Mateo";
let sentence: string = `My name is ${firstName}.
    I am new to TypeScript.`;
console.log(sentence);
El tipo de enumeración
typescript
// Valores secuenciales comenzando en 0
enum ContractStatus1 {
    Permanent,    // 0
    Temp,         // 1
    Apprentice    // 2
}

// Valores personalizados
enum ContractStatus2 {
    Permanent = 1,  // 1
    Temp,           // 2
    Apprentice      // 3
}
Tipos any y unknown
Tipo any
typescript
let randomValue: any = 10;
randomValue = 'Mateo';   // OK
randomValue = true;      // OK
Tipo unknown
typescript
let randomValue: unknown = 10;
randomValue = true;
randomValue = 'Mateo';

// Las siguientes líneas generarían error:
// console.log(randomValue.name);
// randomValue();
// randomValue.toUpperCase();
Aserciones de tipos
typescript
let randomValue: unknown = 'Mateo';

if (typeof randomValue === "string") {
    console.log((randomValue as string).toUpperCase());  // Devuelve 'MATEO'
} else {
    console.log("Error - Se esperaba una cadena.");
}
Tipos de unión e intersección
Tipos de unión
typescript
let multiType: number | boolean;
multiType = 20;         // Válido
multiType = true;       // Válido
// multiType = "twenty"; // Inválido
Tipos de intersección
typescript
interface Employee {
    employeeID: number;
    age: number;
}

interface Manager {
    stockPlan: boolean;
}

type ManagementEmployee = Employee & Manager;

let newManager: ManagementEmployee = {
    employeeID: 12345,
    age: 34,
    stockPlan: true
};
Tipos literales
Tipos literales de cadena
typescript
type testResult = "pass" | "fail" | "incomplete";
let myResult: testResult;
myResult = "incomplete";  // Válido
myResult = "pass";        // Válido
// myResult = "failure";   // Inválido
Tipos literales numéricos
typescript
type dice = 1 | 2 | 3 | 4 | 5 | 6;
let diceRoll: dice;
diceRoll = 1;  // Válido
diceRoll = 2;  // Válido
// diceRoll = 7;  // Inválido
Tipos de colección
Matrices (Arrays)
typescript
let list1: number[] = [1, 2, 3];
let list2: Array<number> = [1, 2, 3];  // Equivalente
Tuplas
typescript
let person1: [string, number] = ['Marcia', 35];  // Válido
// let person2: [string, number] = ['Marcia', 35, true];  // Error
// let person3: [string, number] = [35, 'Marcia'];        // Error
¿Qué es una interfaz?
Definición básica
typescript
interface Employee {
    firstName: string;
    lastName: string;
    fullName(): string;
}
Implementación de interfaz
typescript
let employee: Employee = {
    firstName: "Emil",
    lastName: "Andersson",
    fullName(): string {
        return this.firstName + " " + this.lastName;
    }
};

// employee.firstName = 10;  // Error: Type 'number' is not assignable to type 'string'
Interfaz vs Alias de tipo
typescript
// Como interfaz
interface EmployeeInterface {
    firstName: string;
    lastName: string;
    fullName(): string;
}

// Como alias de tipo
type EmployeeType = {
    firstName: string;
    lastName: string;
    fullName(): string;
};

// Extensión de interfaz
interface ExtendedEmployee extends EmployeeInterface {
    department: string;
}

// Los alias de tipo permiten uniones y tuplas
type Status = "active" | "inactive" | "pending";
type Coordinates = [number, number];
Comentarios y conclusiones importantes
Inferencia de tipos: Siempre que sea posible, permite que el compilador infiera los tipos para mejorar la legibilidad y reducir redundancia.

BigInt: Útil para manejar números más allá del rango de number en JavaScript (más allá de 2^53 - 1).

Template literals: Mejoran la legibilidad y permiten interpolación de expresiones complejas.

Enums: Útiles para valores constantes legibles. El valor por defecto es 0 pero se puede personalizar.

any vs unknown: Evita usar any cuando sea posible, ya que desactiva el sistema de tipos. Usa unknown para mayor seguridad.

Aserciones de tipo: Útiles cuando estás seguro del tipo de una variable, pero úsalas con precaución.

Tipos de unión: Permiten flexibilidad manteniendo el control de tipos.

Tipos de intersección: Útiles para combinar propiedades de múltiples tipos.

Tipos literales: Restringen valores a conjuntos finitos, útiles para validación o estados predefinidos.

Arrays: Ambas sintaxis ([] y Array<type>) son equivalentes, es cuestión de preferencia.

Tuplas: Útiles para estructuras de datos heterogéneas de longitud fija.

Interfaces: Fundamentales para definir estructuras de objetos y garantizar consistencia. Son extensibles (se pueden reabrir y agregar propiedades).

Alias de tipo vs Interface:

Las interfaces son mejores para extensibilidad y consistencia

Los alias son mejores para uniones, tuplas y combinaciones más flexibles

Razones para usar interfaces:

Crear nombres abreviados para tipos frecuentes

Controlar coherencia en conjuntos de objetos

Describir APIs de JavaScript existentes

Mejorar comunicación entre módulos o equipos de desarrollo

Diferencia clave entre any y unknown:
any: Omite todas las comprobaciones de tipo

unknown: Requiere comprobaciones antes de interactuar con el valor, mejorando la seguridad del código

Diferencia clave entre interfaces y alias de tipo:
Interfaces: Extensibles, se pueden "abrir" nuevamente para añadir propiedades

Alias de tipo: No se pueden modificar una vez declarados, pero permiten describir uniones y tuplas