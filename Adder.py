def adder(num1, num2):
    # Calculate the sum
    result = num1 + num2
    
    # Display the result
    print(f"The sum of {num1} and {num2} is {result}")

def main():
    # Get input from the user
    num1 = float(input("Enter the first number : "))
    num2 = float(input("Enter the second number : "))
    
    # Call the function with the input variables
    adder(num1, num2)

# Call the main function
if __name__ == "__main__":
    main()
