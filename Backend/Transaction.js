const mongoose = require("mongoose");

const transactionSchema = new mongoose.Schema({
	ID: { type: Number, required: true, unique: true },
	senderUsername: { type: String, required: true },
	senderName: { type: String, required: true },
	senderCardNumber: { type: String, unique: true },
	receiverUsername: { type: String, required: true },
	receiverName: { type: String, required: true },
	receiverCardNumber: { type: String, unique: true },
	amount: { type: Number },
	date: { type: Date, default: Date.now, required: true },
});

// Auto-increment and generate ID
transactionSchema.pre("save", function (next) {
	var doc = this;
	mongoose
		.model("Transaction", transactionSchema)
		.findOne({}, {}, { sort: { ID: -1 } }, function (err, lastTransaction) {
			if (err) {
				next(err);
			} else if (lastTransaction) {
				doc.ID = lastTransaction.ID + 1;
				next();
			} else {
				doc.ID = 1;
				next();
			}
		});
});

const Transaction = mongoose.model("Transaction", transactionSchema);
module.exports = Transaction;
