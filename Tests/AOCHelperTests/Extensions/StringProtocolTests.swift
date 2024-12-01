// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper
import Testing

struct StringProtocolTests {
    @Test(arguments: [
        ("1", 1),
        ("16384", 16384),
        ("    16385", 16385),
        ("16386     ", 16386),
        ("    16387     ", 16387),
        (
            """
            
              16388  
            
            """,
            16388
        ),
        (Substring(stringLiteral: "123"), 123),
        (Substring(stringLiteral: "  124"), 124),
        (Substring(stringLiteral: "125  "), 125),
        (Substring(stringLiteral: "  126  "), 126),
        (
            Substring(
                stringLiteral: """
                    
                      127  
                    
                    """
            ),
            127
        ),
    ])
    func testToInt(input: any StringProtocol & Sendable, expectedResult: Int) {
        let result = input.toInt()
        #expect(result == expectedResult)
    }
}
