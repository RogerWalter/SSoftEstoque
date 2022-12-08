class Planilha{
  var _credentials = r'''
{
  "type": "service_account",
  "project_id": "estoque-teccel",
  "private_key_id": "6ebda77b770c62da36df3b7c96d2282b028139a6",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC5ActiaJJAbfO5\ndZS9Dlu1+i97uhhc6RLLljnJtT6r7d/vMHDxCWTTshB6ZASvKObjELvXPpmg+vNE\nKU9U1q5pNEbqyiBZ6Vw8Qgl1BjOqFT3Dm1x66+P6NHJI7iNXFVpkJZWGWcr0t0aJ\n4ysszXI7fBA3sQ2t/VsK3Lkhvpw+sTDE7TkVVsINoV0d40PB2GWeYaEMYGBhDezq\nmnr/N9k36ZbqVjOI/NxpEskucMbcBa58Mp+ihNoDWLZsadkm/nEilBQOS2DVYA+/\noWfpVa/U39ylVth9Q7wc6R4KxzkaLOaMNBE+t3aMUtTMuk8+PwtP3pASatn07tmB\nF/NiwSq5AgMBAAECggEAVtsw0RKnFviH5Bn/qoKDK/w5Lq0/ot8Jo+rzVm9w7ObQ\nq0riu0bdv0Vp1wv95v4c552DkpohJiKq8uUyCXKAj4Orh689YPjeBKw8JGS0/LTc\nOmlGEa+NaHoW7YZfsRKlTT8X4+tkDV++Dh5Its/9QVANjRfihDzd8UuO3vjOAeAB\nMkxfBMdLsZdvGH/s56u5bbvOOgXETEQC+EgpCzui6x+iTuzZ+qcnFa2LAjf1euwT\nqL1zptpq9VIIIQnMk/tRd3PgLV1qdWVvsFNTy718E11HjKhfkB8ranTqRtR7i8tc\nSu8z1dtTk6y0aZeTt9d1WMOMMhEoncyjiXowEOlKwQKBgQDr8cyMwImbe5maywsh\n0SQacl3qsqP8Rgmf7+DagLiNxyHoPPUIkVvfKpv7K/VtSqjDPkDBjNRSrxejmZt2\n77DMPDShikNL6NMittsiRgZFkye23bqMi8ZTNZqxtWfwFdvTJrpkAblwsMIQd+uB\n2VdWLt5OI7ckn9CffVn9YNHAWwKBgQDIu5Wt61BGclIJi9R+RBogGACNCH8Iw8Al\nmupW+xBIlrMRvAfEQ+Z3WKa5YJOl0x0p52dye9AQc0wk5yiHgnQScGEdTiLGW0/H\ncesdCt7+BM2fgbhq5A4FYPrqCgiZ0lZVX8nUEZmzdh8ky3Sy6DTxkOKplyCmKjU/\nBcICKaltewKBgQCLO6trvAr4V93zPLKbCCH4AVlusHCY5HO1kAbuqls+Py7BL4eh\nwLWoYiqd8/jmv9ILNWddUE/TY0Pd5T2a2CNKwpSEZ2UDHKfLqoByH0SANjCPdxUo\n7yrf25goGlb1lNCeMBJ6BZJ677P1p+6wN6OUViAVmHnxAOZJ190M6t+cVQKBgQC8\nbdqD+HDSsF3yOCCwpp0fo2hg+6jEQX0Nz+5K2ELg4RYXf7qKsnKVddKMEeyHrTWj\nMGYbQb5+sry3p4aULhFnfbasG7zpFq49OuLJ0HqjWT7sjIjhTlMbGX5wVBreymPg\noJqFSEBQBoIVuCdEClYorSkYqZUsZlK1ZmJIRXOWIQKBgFNtEtsEcSbNz9KUuNEs\nSLTMObRoldqiXIRs58SPZRbmC2q1iWIUeIjJHPAyvrW2k93megRz7MnOhWNvEy8T\n413gA4UrRlRm/ozdBcH64PIV86YUx5nJEZGpXvkCfPCO5VItxFAf0kHfqcbagn11\nmpLwV7QNjsKTWU0XW5y1zK67\n-----END PRIVATE KEY-----\n",
  "client_email": "estoque-teccel-sbs@estoque-teccel.iam.gserviceaccount.com",
  "client_id": "114783793400240053458",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/estoque-teccel-sbs%40estoque-teccel.iam.gserviceaccount.com"
}
''';
  var _spreadsheetId_sbs = '14-IfgW9oAKdbeopsPffrLGYeuloDOQIIy_DAqFHpl_U';
  var _spreadsheetId_jve = '1opDJYDRe9ryG5xY40T6jGrkCOOlRwfKIRfuQsmWrrUc';
  var _spreadsheetId_uva = '10aGGdGSgPDnVc0DkCIVpIqI9vGitNU0hQmcbX-AErcA';

  Planilha();

  get credentials => _credentials;

  set credentials(value) {
    _credentials = value;
  }

  get spreadsheetId_uva => _spreadsheetId_uva;

  set spreadsheetId_uva(value) {
    _spreadsheetId_uva = value;
  }

  get spreadsheetId_jve => _spreadsheetId_jve;

  set spreadsheetId_jve(value) {
    _spreadsheetId_jve = value;
  }

  get spreadsheetId_sbs => _spreadsheetId_sbs;

  set spreadsheetId_sbs(value) {
    _spreadsheetId_sbs = value;
  }
}