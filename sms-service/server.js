const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const twilio = require('twilio');

const app = express();
app.use(bodyParser.json());
app.use(cors());

// Twilio credentials
const accountSid = 'AC8ac893476660260c0db7c81ad5d1d5a6';
const authToken = '2c65d4056f5015db84b0cf2b509736de';
const client = new twilio(accountSid, authToken);

// Handle POST request to send SMS
app.post('/send-sms', (req, res) => {
  // Extract phone numbers and messages from the request body
  const { phoneNumbers } = req.body;

  // Iterate over phone numbers and send SMS using Twilio
  phoneNumbers.forEach((student) => {
    const { Phone, Name, Marks } = student;
    client.messages.create({
      body: `${Name}\n${Marks}`,
      to: `+91${Phone}`,
      from: '+918870750384' // From a valid Twilio number
    })
    .then((message) => console.log(`Message sent to ${Phone}`))
    .catch((error) => console.error(error));
  });

  // Send response back to client
  res.send('Messages sent');
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
