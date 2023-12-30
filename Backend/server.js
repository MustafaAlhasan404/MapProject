// Import necessary libraries
const express = require("express");
const bodyParser = require("body-parser");
const mongoose = require("mongoose");
const cors = require("cors");
const readline = require("readline");
const User = require("./User");
const Transaction = require("./Transaction");

const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.json());

// Connect to MongoDB (hosted on Atlas)
mongoose.connect(
	"mongodb+srv://mustafa:mustafa@cluster0.cdvxaix.mongodb.net/test",
	{
		useNewUrlParser: true,
		useUnifiedTopology: true,
	}
);

// Endpoint for handling user signup
app.post("/signup", async (req, res) => {
	const { firstName, lastName, address, birthday, username, password } =
		req.body;

	try {
		console.log("Received signup request:", { username, password });

		// Check if the username already exists in the database
		const existingUser = await User.findOne({ username });
		if (existingUser) {
			console.log("Username already exists");
			return res.status(400).json({ error: "Username already exists" });
		}

		const newUser = new User({
			firstName,
			lastName,
			address,
			birthday,
			username,
			password,
		});

		await newUser.save();

		console.log("Signup successful");
		res.status(200).json({
			message: "Signup successful",
			...newUser,
		});
	} catch (error) {
		console.error("Error:", error);
		res.status(500).json({ error: "Internal Server Error" });
	}
});

// Endpoint for getting user balance
app.get("/getUserBalance/:username", async (req, res) => {
	const username = req.params.username;

	try {
		const user = await User.findOne({ username });

		if (!user) {
			return res.status(404).json({ error: "User not found" });
		}

		const userBalance = {
			balance: user.balance,
		};

		res.status(200).json(userBalance);
	} catch (error) {
		console.error("Error:", error);
		res.status(500).json({ error: "Internal Server Error" });
	}
});

app.get("/users/:username", async (req, res) => {
	const { username } = req.params;
	try {
		const user = await User.findOne({ username });
		if (!user) {
			return res.status(404).send("User not found");
		}
		res.send(user);
	} catch (error) {
		console.error(error);
		res.status(500).send("Server error");
	}
});

// Endpoint for getting credit card information
app.get("/getCreditCardInfo/:username", async (req, res) => {
	const username = req.params.username;

	try {
		const user = await User.findOne({ username });

		if (!user) {
			return res.status(404).json({ error: "User not found" });
		}

		// Extract and send credit card information in the response
		const creditCardInfo = {
			cardNumber: user.creditCardNumber,
			cvv: user.cvv,
			expiryDate: user.expiryDate,
		};

		res.status(200).json(creditCardInfo);
	} catch (error) {
		console.error("Error:", error);
		res.status(500).json({ error: "Internal Server Error" });
	}
});

// Endpoint for handling user login
app.post("/login", async (req, res) => {
	// Extract username and password from the request body
	const { username, password } = req.body;

	try {
		console.log("Received login request:", { username, password });

		// Check if the username exists in the database
		const existingUser = await User.findOne({ username });
		if (!existingUser) {
			console.log("Username not found");
			return res.status(400).json({ error: "Username not found" });
		}

		// Check if the password is correct
		if (password !== existingUser.password) {
			console.log("Incorrect password");
			return res.status(401).json({ error: "Incorrect password" });
		}

		// Login successful
		console.log("Login successful");

		// Additional tasks can be performed here, such as creating a session or generating a token

		// Respond with success
		res.status(200).json({ message: "Login successful" });
	} catch (error) {
		// Handle database or server errors
		console.error("Error:", error);
		res.status(500).json({ error: "Internal Server Error" });
	}
});

app.post("/transferMoney", async (req, res) => {
	try {
		const { senderUsername, recipientCardNumber, amount } = req.body;

		// Verify that the sender user exists
		const senderUser = await User.findOne({ username: senderUsername });
		if (!senderUser) {
			console.log("Sender user not found");
			return res.status(404).json({ error: "Sender user not found" });
		}

		// Verify that the recipient user exists
		const recipientUser = await User.findOne({
			creditCardNumber: recipientCardNumber,
		});
		if (!recipientUser) {
			console.log("Recipient user not found");
			return res.status(404).json({ error: "Recipient user not found" });
		}

		// Check if the provided credit card number matches the recipient's credit card number
		if (recipientUser.creditCardNumber !== recipientCardNumber) {
			console.log("Invalid credit card number for the recipient");
			return res.status(400).json({
				error: "Invalid credit card number for the recipient",
			});
		}

		// Convert the transfer amount to a number
		const transferAmount = parseFloat(amount);

		// Check if the amount is a valid number
		if (isNaN(transferAmount) || transferAmount <= 0) {
			console.log("Invalid transfer amount");
			return res.status(400).json({ error: "Invalid transfer amount" });
		}

		// Check if the sender has enough balance for the transfer
		if (senderUser.balance < transferAmount) {
			console.log("Insufficient balance for the transfer");
			return res
				.status(400)
				.json({ error: "Insufficient balance for the transfer" });
		}

		// Update sender's balance
		senderUser.balance -= transferAmount;
		await senderUser.save();

		// Update recipient's balance
		recipientUser.balance += transferAmount;
		await recipientUser.save();

		console.log("Money transfer successful");
		res.status(200).json({ message: "Money transfer successful" });
	} catch (error) {
		console.error("Error during money transfer:", error);
		res.status(500).json({ error: "Internal Server Error" });
	}
});

// Start the server
app.listen(port, () => {
	console.log(`Server is running on port ${port}`);
});
