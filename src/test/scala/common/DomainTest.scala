package common

import common.Domain.{Amount, Currency, FullName, Id, Person, Symbol}
import org.scalatest.funsuite.AnyFunSuite

class DomainTest extends AnyFunSuite {

  test("FullName") {
    assertThrows[IllegalArgumentException](FullName("jan"))
    assertThrows[IllegalArgumentException](FullName("j n"))
  }

  test("Person") {
    val fullName = "Franta Vomacka"

    assert(Person(Id(1), FullName(fullName)).asString == fullName)
  }

  test("Symbol") {
    assertThrows[IllegalArgumentException](Symbol("jan"))
    assertThrows[IllegalArgumentException](Symbol("AB"))
    assertThrows[IllegalArgumentException](Symbol("ABCDE"))
  }

  test("Amount") {
    assertThrows[IllegalArgumentException](
      Amount(
        BigDecimal("123456789012345678901234567890123456789"),
        Currency.default
      )
    )
    assertThrows[IllegalArgumentException](Amount(BigDecimal("0.000000001"), Currency.default))
  }

  test("Currency") {
    assert(Currency.size == 4)
  }

}
